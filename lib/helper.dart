import 'package:hive/hive.dart';
import 'package:student_registeration/models/student.dart';

var box = Hive.box<Student>('students');
String? studentEmail;
List<Student> students = box.values.toList();
void printdata() {
  print(students);
}
