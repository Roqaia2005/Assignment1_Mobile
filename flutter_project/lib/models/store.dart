import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 1)
class Store extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String address;
  @HiveField(3)
  double latitude;
  @HiveField(4)
  double longitude;
  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'].toString(),
      name: json['name'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
  // factory Store.fromJson(Map<String, dynamic> json) {
  //   return Store(
  //     id: json['id'],
  //     name: json['tags']['name:en'] ?? 'Unnamed',
  //     address: json['tags']['addr:city:en'] ?? 'Unknown Address',
  //     latitude: json['lat'],
  //     longitude: json['lon'],
  //   );
  // }
}
