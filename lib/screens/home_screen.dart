import 'dart:io';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_registeration/helper.dart';
import 'package:student_registeration/models/student.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final picker = ImagePicker();
  File? _image;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();
  Student? studentData;

  String? selectedGender = "Male";

  String? selectedLevel = "Level 1";

  Future<Student?> getStudentData() async {
    if (studentEmail == null) return null;
    print("Student email is: $studentEmail");

    var students = box.values.toList();
    print("Hive values: $students");

    for (var student in students) {
      if (student.email == studentEmail) {
        print("Student found: ${student.name}");
        return student;
      }
    }

    print("No student found with this email");
    return null;
  }

  Future<void> loadUserData() async {
    Student? student = await getStudentData();

    if (student != null) {
      setState(() {
        studentData = student;

        nameController.text = studentData?.name ?? "";
        emailController.text = studentData?.email ?? "";
        studentIdController.text = studentData?.id ?? "";
        passwordController.text = studentData?.password ?? "";
        selectedGender = studentData?.gender ?? "Male";
        selectedLevel = studentData?.level ?? "Level 1";
        if (studentData?.image != null) {
          _image = File(studentData!.image!);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        if (studentData != null) {
          studentData!.image = _image!.path;
          box.put(studentData!.id, studentData!);
        }
      });
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: Colors.pinkAccent),
              title: const Text("Upload from Gallery"),
              onTap: () {
                pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera, color: Colors.pinkAccent),
              title: const Text("Take a Photo"),
              onTap: () {
                pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateProfile() async {
    Student updatedStudent = Student(
      name: nameController.text,
      email: emailController.text,
      id: studentIdController.text,
      password: passwordController.text,
      gender: selectedGender,
      level: selectedLevel,
      image: _image?.path,
    );

    await box.put(studentIdController.text, updatedStudent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.pinkAccent.shade100.withOpacity(0.2),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage("assets/images/person.jpg")
                            as ImageProvider,
                  ),
                  InkWell(
                    onTap: _showImagePickerModal,
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.pinkAccent,
                      child: Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildEditableField("Name", nameController),
                    const SizedBox(height: 12),
                    buildGenderSelector(),
                    const SizedBox(height: 12),
                    buildEditableField("Email", emailController),
                    buildEditableField("Student ID", studentIdController),
                    const SizedBox(height: 12),
                    buildEditableField("Password", passwordController,
                        obscureText: true),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                  elevation: 3,
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red, size: 22),
                label: const Text(
                  "Log out",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.pinkAccent, fontWeight: FontWeight.bold),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(
              fontSize: 16,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Male"),
                value: "Male",
                groupValue: selectedGender,
                activeColor: Colors.pinkAccent,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Female"),
                value: "Female",
                groupValue: selectedGender,
                activeColor: Colors.pinkAccent,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget buildLevelDropdown() {
  //   List<String> levels = ["Level 1", "Level 2", "Level 3", "Level 4"];
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: DropdownButtonFormField<String>(
  //       value: selectedLevel,
  //       items: levels.map((level) {
  //         return DropdownMenuItem<String>(
  //           value: level,
  //           child: Text(level, style: const TextStyle(fontSize: 16)),
  //         );
  //       }).toList(),
  //       onChanged: (value) {
  //         setState(() {
  //           selectedLevel = value!;
  //         });
  //       },
  //       decoration: InputDecoration(
  //         labelText: "Level",
  //         labelStyle: const TextStyle(
  //             color: Colors.pinkAccent, fontWeight: FontWeight.bold),
  //         filled: true,
  //         fillColor: Colors.white.withOpacity(0.8),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide.none,
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(color: Colors.grey.shade300),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
