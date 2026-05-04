import 'package:flutter/foundation.dart';
import 'package:invoice_app/core/database/dao/invoice_dao.dart';
import 'package:invoice_app/core/database/dao/invoice_item_dao.dart';
import 'package:invoice_app/core/database/database_helper.dart';
import 'package:invoice_app/core/services/notification_service.dart';
import 'package:invoice_app/models/invoice.dart';
import 'package:invoice_app/models/invoice_item.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceDao _invoiceDao = InvoiceDao();
  final InvoiceItemDao _itemDao = InvoiceItemDao();
  final NotificationService _notificationService = NotificationService();

  List<Invoice> _invoices = [];
  List<Invoice> get invoices => _invoices;

  Invoice? _selectedInvoice;
  Invoice? get selectedInvoice => _selectedInvoice;

  List<InvoiceItem> _currentItems = [];
  List<InvoiceItem> get currentItems => _currentItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _invoices = await _invoiceDao.getAll();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createInvoice(Invoice invoice, List<InvoiceItem> items) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final db = await DatabaseHelper.instance.database;
    try {
      final id = await db.transaction((txn) async {
        final id = await txn.insert('invoices', invoice.toMap());
        for (var item in items) {
          final itemWithInvoiceId = item.copyWith(invoiceId: id);
          await txn.insert('invoice_items', itemWithInvoiceId.toMap());
        }
        return id;
      });
      
      final createdInvoice = invoice.copyWith(id: id);
      _invoices.insert(0, createdInvoice);
      
      if (createdInvoice.status == InvoiceStatus.unpaid) {
        // Schedule reminder outside transaction
        _notificationService.scheduleReminder(
          invoiceId: id,
          invoiceNumber: createdInvoice.invoiceNumber,
          dueDate: createdInvoice.dueDate,
        ).catchError((e) => debugPrint('Failed to schedule reminder: $e'));
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateInvoice(Invoice invoice, List<InvoiceItem> items) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final db = await DatabaseHelper.instance.database;
    try {
      await db.transaction((txn) async {
        await txn.update(
          'invoices', 
          invoice.toMap(),
          where: 'id = ?',
          whereArgs: [invoice.id]
        );
        
        await txn.delete(
          'invoice_items',
          where: 'invoice_id = ?',
          whereArgs: [invoice.id]
        );

        for (var item in items) {
          final itemWithInvoiceId = item.copyWith(invoiceId: invoice.id, id: null);
          await txn.insert('invoice_items', itemWithInvoiceId.toMap());
        }
      });

      final index = _invoices.indexWhere((inv) => inv.id == invoice.id);
      if (index != -1) {
        _invoices[index] = invoice;
      }

      if (invoice.status == InvoiceStatus.unpaid) {
        _notificationService.scheduleReminder(
          invoiceId: invoice.id!,
          invoiceNumber: invoice.invoiceNumber,
          dueDate: invoice.dueDate,
        ).catchError((e) => debugPrint('Failed to schedule reminder: $e'));
      } else {
        _notificationService.cancelReminder(invoice.id!)
            .catchError((e) => debugPrint('Failed to cancel reminder: $e'));
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleStatus(int invoiceId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final index = _invoices.indexWhere((inv) => inv.id == invoiceId);
      if (index != -1) {
        final invoice = _invoices[index];
        final newStatus = invoice.status == InvoiceStatus.paid
            ? InvoiceStatus.unpaid
            : InvoiceStatus.paid;
        
        final updatedInvoice = invoice.copyWith(status: newStatus);
        await _invoiceDao.update(updatedInvoice);
        _invoices[index] = updatedInvoice;

        if (newStatus == InvoiceStatus.paid) {
          await _notificationService.cancelReminder(invoiceId);
        } else {
          await _notificationService.scheduleReminder(
            invoiceId: updatedInvoice.id!,
            invoiceNumber: updatedInvoice.invoiceNumber,
            dueDate: updatedInvoice.dueDate,
          );
        }
        
        if (_selectedInvoice?.id == invoiceId) {
          _selectedInvoice = updatedInvoice;
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteInvoice(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _invoiceDao.delete(id);
      _invoices.removeWhere((inv) => inv.id == id);
      await _notificationService.cancelReminder(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<InvoiceItem>> getItemsForInvoice(int invoiceId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentItems = await _itemDao.getByInvoice(invoiceId);
      return _currentItems;
    } catch (e) {
      _errorMessage = e.toString();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
