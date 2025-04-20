import 'package:flutter/material.dart';
import 'package:student_registeration/helper.dart';
import 'package:student_registeration/models/store.dart';

class FavStores extends StatelessWidget {
  const FavStores({super.key});

  @override
  Widget build(BuildContext context) {
    final currentStudent = box.values.first;
    final favStoreIds = currentStudent.favStores ?? [];
    final favStores = storesBox.values
        .cast<Store>()
        .where((store) => favStoreIds.contains(store.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: favStores.isEmpty
          ? const Center(
              child: Text('No favorite stores yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favStores.length,
              itemBuilder: (context, index) {
                final store = favStores[index];
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
                    trailing: const Icon(Icons.storefront,
                        color: Color.fromARGB(255, 255, 123, 167)),
                  ),
                );
              },
            ),
    );
  }
}
