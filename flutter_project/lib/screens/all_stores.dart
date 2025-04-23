import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_registeration/helper.dart';
import 'package:student_registeration/models/store.dart';
import 'package:student_registeration/models/student.dart';
import 'package:student_registeration/provider/fav_provider.dart';

class AllStoresScreen extends StatefulWidget {
  const AllStoresScreen({super.key});

  @override
  State<AllStoresScreen> createState() => _AllStoresScreenState();
}

class _AllStoresScreenState extends State<AllStoresScreen> {
  List<Store> stores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    storeInHive();
  }

  Future<void> storeInHive() async {
// if stores box has data get data from it , else get data form  api
    if (storesBox.isNotEmpty) {
      setState(() {
        stores = storesBox.values.cast<Store>().toList();
        isLoading = false;
      });
    } else {
      // box is empty so fetch data from api first
      await fetchAndStoreStoresFromApi();
    }
  }

  Future<void> fetchAndStoreStoresFromApi() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8080/api/stores'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (var item in data) {
          final store = Store.fromJson(item);
          await storesBox.add(store);
        }

        setState(() {
          stores = storesBox.values.cast<Store>().toList();
          isLoading = false;
        });
      } else {
        print('Failed to fetch stores. Status: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching stores: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Stores'),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                    leading: IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        Provider.of<FavProvider>(context, listen: false)
                            .toggleFavorite(store.id);

                        final Student currentStudent = box.values.first;
                        currentStudent.favStores ??= [];
                        if (currentStudent.favStores!.contains(store.id)) {
                          currentStudent.favStores!.remove(store.id);
                        } else {
                          currentStudent.favStores!.add(store.id);
                        }
                        currentStudent.save();
                      },
                      color:
                          Provider.of<FavProvider>(context).isFavorite(store.id)
                              ? Colors.red
                              : Colors.grey,
                    ),
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
