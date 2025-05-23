import 'dart:io';
import 'dart:ui';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_registeration/helper.dart';
import 'package:student_registeration/models/student.dart';
import 'package:student_registeration/screens/distance.dart';
import 'package:student_registeration/screens/fav_stores.dart';
import 'package:student_registeration/screens/all_stores.dart';

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

  String? selectedGender;
  String? selectedLevel;

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
      print("Retrieved Gender: ${student.gender}");
      setState(() {
        studentData = student;

        nameController.text = studentData?.name ?? "";
        emailController.text = studentData?.email ?? "";
        studentIdController.text = studentData?.id ?? "";
        passwordController.text = studentData?.password ?? "";
        selectedGender = studentData?.gender;
        selectedLevel = studentData?.level;
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
      level: selectedLevel ?? "1",
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        title: const Text("Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/images/home.jpg",
                  fit: BoxFit.cover,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // color: Colors.white.withOpacity(0.2),
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: Column(
                children: [
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: buildEditableField("Name", nameController),
                  //     ),
                  //     const SizedBox(width: 16),
                  //     Stack(
                  //       alignment: Alignment.bottomRight,
                  //       children: [
                  //         CircleAvatar(
                  //           radius: 40,
                  //           backgroundColor: Colors.white,
                  //           backgroundImage: _image != null
                  //               ? FileImage(_image!)
                  //               : const AssetImage("assets/images/person.jpg") as ImageProvider,
                  //         ),
                  //         InkWell(
                  //           onTap: _showImagePickerModal,
                  //           child: const CircleAvatar(
                  //             radius: 16,
                  //             backgroundColor: Colors.pinkAccent,
                  //             child: Icon(Icons.edit, color: Colors.white, size: 16),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),

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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: buildEditableField("Name", nameController),
                            ),
                            const SizedBox(width: 16),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : const AssetImage(
                                              "assets/images/person.jpg")
                                          as ImageProvider,
                                ),
                                InkWell(
                                  onTap: _showImagePickerModal,
                                  child: const CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.pinkAccent,
                                    child: Icon(Icons.edit,
                                        color: Colors.white, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        buildGenderSelector(),
                        const SizedBox(height: 10),
                        buildEditableField("Email", emailController,
                            readOnly: true),
                        buildEditableField("Student ID", studentIdController,
                            readOnly: true),
                        const SizedBox(height: 12),
                        buildLevelDropdown(),
                        const SizedBox(height: 12),
                        buildEditableField("Password", passwordController,
                            obscureText: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        elevation: 3,
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllStoresScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          elevation: 3,
                        ),
                        child: const Text(
                          "All Stores",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FavStores()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Favourite Stores",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DistanceScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Distance from favorite stores",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
        ],
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller,
      {bool obscureText = false, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
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
              fontSize: 14,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text(
                  "Male",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    ),
                ),
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
                title: const Text(
                  "Female",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    ),
                ),
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

  Widget buildLevelDropdown() {
    List<String> levels = ["1", "2", "3", "4", ""];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Level",
          style: TextStyle(
              fontSize: 16,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          value: selectedLevel,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: levels
              .map((level) => DropdownMenuItem<String>(
                  value: level, child: Text("Level $level")))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedLevel = value;
            });
          },
        ),
      ],
    );
  }
}
