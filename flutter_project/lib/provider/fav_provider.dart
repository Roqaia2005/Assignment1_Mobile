import 'package:flutter/material.dart';

class FavProvider extends ChangeNotifier {
  final List<String> _favIds = [];

  List<String> get favIds => _favIds;

  void toggleFavorite(String storeId) {
    final isExist = _favIds.contains(storeId);
    if (isExist) {
      _favIds.remove(storeId);
    } else {
      _favIds.add(storeId);
    }
    notifyListeners();
  }

  bool isFavorite(String storeId) {
    return _favIds.contains(storeId);
  }
}
