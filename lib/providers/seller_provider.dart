import 'package:flutter/foundation.dart';
import 'package:little_invoice/core/database/dao/seller_dao.dart';
import 'package:little_invoice/models/seller_profile.dart';

class SellerProvider extends ChangeNotifier {
  final SellerDao _dao = SellerDao();

  SellerProfile? _profile;
  SellerProfile? get profile => _profile;

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
      _profile = await _dao.getFirst();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile(SellerProfile profile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (profile.id == null) {
        final id = await _dao.insert(profile);
        _profile = profile.copyWith(id: id);
      } else {
        await _dao.update(profile);
        _profile = profile;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateImagePath(String field, String path) async {
    if (_profile == null) return;

    SellerProfile updated;
    if (field == 'logo') {
      updated = _profile!.copyWith(logoPath: path);
    } else if (field == 'stamp') {
      updated = _profile!.copyWith(stampPath: path);
    } else if (field == 'signature') {
      updated = _profile!.copyWith(signaturePath: path);
    } else {
      return;
    }

    await saveProfile(updated);
  }
}
