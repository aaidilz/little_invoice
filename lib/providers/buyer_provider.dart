import 'package:flutter/foundation.dart';
import 'package:little_invoice/core/database/dao/buyer_dao.dart';
import 'package:little_invoice/models/buyer.dart';

class BuyerProvider extends ChangeNotifier {
  final BuyerDao _dao = BuyerDao();

  List<Buyer> _buyers = [];
  List<Buyer> get buyers => _buyers;

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
      _buyers = await _dao.getAll();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBuyer(Buyer buyer) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final id = await _dao.insert(buyer);
      _buyers.add(buyer.copyWith(id: id));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBuyer(Buyer buyer) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _dao.update(buyer);
      final index = _buyers.indexWhere((b) => b.id == buyer.id);
      if (index != -1) {
        _buyers[index] = buyer;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBuyer(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _dao.delete(id);
      _buyers.removeWhere((b) => b.id == id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
