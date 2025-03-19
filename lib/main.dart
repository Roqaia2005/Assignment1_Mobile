import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:student_registeration/helper.dart';
import 'package:student_registeration/models/student.dart';
import 'package:student_registeration/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(StudentAdapter());

  await Hive.openBox<Student>('students');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("hive valuesssssssssssssssssssssssss${box.values.toList()}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
