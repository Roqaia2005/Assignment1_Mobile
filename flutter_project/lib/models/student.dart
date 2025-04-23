import 'package:hive/hive.dart';
part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? id;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? password;
  @HiveField(4)
  String? gender;
  @HiveField(5)
  String? level;
  @HiveField(6)
  String? image;
  @HiveField(7)
  List<int>? favStores;

  Student(
      {this.name,
      this.id,
      this.email,
      this.password,
      this.gender,
      this.level,
      this.image,
      this.favStores});

  Student.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    level = json['level'];
    image = json['image'];
    favStores = List<int>.from(json['favStores'] ?? []);
  }
  @override
  String toString() {
    return 'Student{name: $name, email: $email, id: $id, password: $password, gender: $gender, level: $level, image: $image, favStores: $favStores}';
  }
}
