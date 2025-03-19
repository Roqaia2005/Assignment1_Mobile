import 'package:hive/hive.dart';
import 'package:student_registeration/models/student.dart';

late Box<Student> box;

Future<void> initializeHive() async {
  box = await Hive.openBox<Student>('students');
}