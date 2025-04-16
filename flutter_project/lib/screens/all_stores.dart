import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:student_registeration/models/store.dart';

class AllStoresScreen extends StatelessWidget {
  const AllStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Store>('stores');
    final stores = box.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Stores'),
        backgroundColor: Colors.pinkAccent.withOpacity(0.7),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(store.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(store.address),
              trailing: const Icon(Icons.storefront, color: Colors.pinkAccent),
            ),
          );
        },
      ),
    );
  }
}
