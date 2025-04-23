import 'package:flutter/foundation.dart';
import 'package:student_registeration/helper.dart';
import 'package:student_registeration/models/student.dart';

class FavProvider extends ChangeNotifier {
  List<int> _favIds = [];

  void load(Student student) {
    _favIds = List<int>.from(student.favStores ?? []);
    notifyListeners();
  }

  List<int> get favIds => _favIds;

  void toggleFavorite(int storeId) {
    if (_favIds.contains(storeId)) {
      _favIds.remove(storeId);
    } else {
      _favIds.add(storeId);
    }

    final currentStudent = box.values.firstWhere((s) => s.email == studentEmail);
    currentStudent.favStores = _favIds;
    currentStudent.save();

    notifyListeners();
  }

  bool isFavorite(int storeId) => _favIds.contains(storeId);
}
