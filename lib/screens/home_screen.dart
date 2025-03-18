import 'dart:io';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_registeration/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final picker = ImagePicker();
  File? _image;
  String? _fileName;
  String? _filePath;
  int? _fileSize;
  File _placeHolder = File("assets/images/person.jpg");
  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _fileName = pickedFile.name;
        _filePath = pickedFile.path;
        _fileSize = File(pickedFile.path).lengthSync();
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _fileName = pickedFile.name;
        _filePath = pickedFile.path;
        _fileSize = File(pickedFile.path).lengthSync();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Container(
              color: Colors.grey.withOpacity(0.5),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Email: email@stud.fci-cu.edu.eg',
                      softWrap: true,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black,
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),
                  ),
                  const VerticalDivider(thickness: 2, color: Colors.grey),
                  Expanded(
                    child: Text(
                      'ID: 20220424',
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 100),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image(image: FileImage(_image ?? _placeHolder)),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              pickImageFromGallery();
            },
            child: Text(
              "Upload from Gallery",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              pickImageFromCamera();
            },
            child: Text(
              "Take photo",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),

          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              print(box.values.toList());
            },
            child: Text(
              "Edit Profile",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout, color: Colors.red, size: 20),
                SizedBox(width: 3),
                TextButton(
                  onPressed: () async {
                    // await MyCache.clear();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
