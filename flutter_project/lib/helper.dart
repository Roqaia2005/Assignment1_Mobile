import 'package:hive/hive.dart';
import 'package:student_registeration/models/store.dart';
import 'package:student_registeration/models/student.dart';

var box = Hive.box<Student>('students');
var storesBox = Hive.box<Store>('stores');

String? studentEmail;
