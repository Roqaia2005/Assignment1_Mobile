import 'package:flutter/material.dart';

class FavProvider extends ChangeNotifier {
  final List<int> _favIds = [];

  List<int> get favIds => _favIds;

  void toggleFavorite(int storeId) {
    final isExist = _favIds.contains(storeId);
    if (isExist) {
      _favIds.remove(storeId);
    } else {
      _favIds.add(storeId);
    }
    notifyListeners();
  }

  bool isFavorite(int storeId) {
    return _favIds.contains(storeId);
  }
}
