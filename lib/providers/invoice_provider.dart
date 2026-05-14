import 'package:flutter/foundation.dart';
import 'package:little_invoice/core/database/dao/invoice_dao.dart';
import 'package:little_invoice/core/database/dao/invoice_item_dao.dart';
import 'package:little_invoice/core/database/database_helper.dart';
import 'package:little_invoice/core/services/notification_service.dart';
import 'package:little_invoice/models/invoice.dart';
import 'package:little_invoice/models/invoice_item.dart';

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
    if (kIsWeb) return; // Skip for web

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

    try {
      if (kIsWeb) {
        final nextId = (_invoices
                .map((i) => i.id ?? 0)
                .fold<int>(0, (maxId, id) => id > maxId ? id : maxId)) +
            1;
        final createdInvoice = invoice.copyWith(id: nextId);
        _invoices.insert(0, createdInvoice);
        _currentItems.addAll(items
            .map((item) => item.copyWith(invoiceId: nextId, id: null))
            .toList());
      } else {
        final db = await DatabaseHelper.instance.database;
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
          _notificationService
              .scheduleReminder(
                invoiceId: id,
                invoiceNumber: createdInvoice.invoiceNumber,
                dueDate: createdInvoice.dueDate,
              )
              .catchError((e) => debugPrint('Failed to schedule reminder: $e'));
        }
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

    try {
      if (!kIsWeb) {
        final db = await DatabaseHelper.instance.database;
        await db.transaction((txn) async {
          await txn.update('invoices', invoice.toMap(),
              where: 'id = ?', whereArgs: [invoice.id]);

          await txn.delete('invoice_items',
              where: 'invoice_id = ?', whereArgs: [invoice.id]);

          for (var item in items) {
            final itemWithInvoiceId =
                item.copyWith(invoiceId: invoice.id, id: null);
            await txn.insert('invoice_items', itemWithInvoiceId.toMap());
          }
        });
      } else {
        _currentItems.removeWhere((item) => item.invoiceId == invoice.id);
        _currentItems.addAll(items
            .map((item) => item.copyWith(invoiceId: invoice.id!, id: null))
            .toList());
      }

      final index = _invoices.indexWhere((inv) => inv.id == invoice.id);
      if (index != -1) {
        _invoices[index] = invoice;
      }

      if (invoice.status == InvoiceStatus.unpaid) {
        _notificationService
            .scheduleReminder(
              invoiceId: invoice.id!,
              invoiceNumber: invoice.invoiceNumber,
              dueDate: invoice.dueDate,
            )
            .catchError((e) => debugPrint('Failed to schedule reminder: $e'));
      } else {
        _notificationService
            .cancelReminder(invoice.id!)
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

        if (!kIsWeb) {
          final updatedInvoice = invoice.copyWith(status: newStatus);
          await _invoiceDao.update(updatedInvoice);
          _invoices[index] = updatedInvoice;
        } else {
          _invoices[index] = invoice.copyWith(status: newStatus);
        }

        if (newStatus == InvoiceStatus.paid) {
          await _notificationService.cancelReminder(invoiceId);
        } else {
          await _notificationService.scheduleReminder(
            invoiceId: invoiceId,
            invoiceNumber: _invoices[index].invoiceNumber,
            dueDate: _invoices[index].dueDate,
          );
        }

        if (_selectedInvoice?.id == invoiceId) {
          _selectedInvoice = _invoices[index];
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
      if (!kIsWeb) {
        await _invoiceDao.delete(id);
      } else {
        _currentItems.removeWhere((item) => item.invoiceId == id);
      }
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
      if (kIsWeb) {
        return _currentItems
            .where((item) => item.invoiceId == invoiceId)
            .toList();
      }
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
