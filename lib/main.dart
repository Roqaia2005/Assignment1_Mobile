import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:student_registeration/helper.dart';
import 'package:student_registeration/models/student.dart';
import 'package:student_registeration/screens/login_screen.dart';
import 'models/store.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// Future<void> seedStoresFromJson() async {
//   final storeBox = Hive.box<Store>('stores');
//   if (storeBox.isNotEmpty) return;

//   final String data = await rootBundle.loadString('../assets/stores.json');
//   final List<dynamic> storesJson = json.decode(data);

//   for (var item in storesJson) {
//     await storeBox.add(Store(
//       name: item['name'],
//       address: item['address'],
//       latitude: item['latitude'],
//       longitude: item['longitude'],
//     ));
//   }
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0))
    Hive.registerAdapter(StudentAdapter());
  await Hive.openBox<Student>('students');

  if (!Hive.isAdapterRegistered(1))
    Hive.registerAdapter(StoreAdapter());

  await Hive.openBox<Store>('stores');
  // await seedStoresFromJson();
  // print("📦 Seeded stores: ${Hive.box<Store>('stores').values.toList()}");

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
