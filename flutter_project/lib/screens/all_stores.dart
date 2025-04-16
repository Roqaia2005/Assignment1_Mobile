import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:student_registeration/models/store.dart';

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
    fetchStores();
  }

  Future<void> fetchStores() async {
    try {
      final response = await Dio().get('http://localhost:8080/api/stores');
      final List<dynamic> data = response.data;

      setState(() {
        stores = data.map((json) => Store.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching stores: $e');
      setState(() {
        isLoading = false;
      });
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
