import 'package:hive/hive.dart';
part 'student.g.dart';

@HiveType(typeId: 1)
class Student {
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? email;
  @HiveField(4)
  String? password;
  @HiveField(5)
  String? gender;
  @HiveField(6)
  String? level;

  Student({
    this.name,
    this.id,
    this.email,
    this.password,
    this.gender,
    this.level,
  });

  Student.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    level = json['level'];
  }
}
