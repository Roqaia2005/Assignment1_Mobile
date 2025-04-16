// main.dart

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:student_registeration/helper.dart';
import 'package:student_registeration/models/student.dart';
import 'package:student_registeration/screens/login_screen.dart';
import 'package:student_registeration/models/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchAndStoreStoresFromApi() async {
  final box = Hive.box<Store>('stores');
  if (box.isNotEmpty) return; // Skip if already populated

  final response = await http.get(Uri.parse('https://your-api-url.com/stores'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    for (var item in data) {
      final store = Store.fromJson(item);
      await box.add(store);
    }
    print('Stores fetched and saved!');
  } else {
    print('Failed to fetch stores. Status: ${response.statusCode}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(StudentAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(StoreAdapter());

  await Hive.openBox<Student>('students');
  await Hive.openBox<Store>('stores');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await fetchAndStoreStoresFromApi();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
