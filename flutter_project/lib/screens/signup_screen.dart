import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_registeration/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_registeration/models/student.dart';
import 'package:student_registeration/screens/login_screen.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  TextEditingController ?levelController;

  String? gender;
  final _formKey = GlobalKey<FormState>();
  bool obscure = true;
  bool obscureConfirm = true;
  late StreamSubscription<InternetStatus> listener;

  @override
  void initState() {
    super.initState();
    listener = InternetConnection().onStatusChange.listen((status) async {
      if (status == InternetStatus.connected) {
        if (box.isNotEmpty) {
          await syncOfflineUsersToFirebase();
        }
      }
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/home.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.white.withOpacity(0.4),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildTextField("ID", idController, false),
                      const SizedBox(height: 10),
                      buildTextField("Name", nameController, false),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Male'),
                              value: 'Male',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Female'),
                              value: 'Female',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      buildTextField("Email", emailController, false,
                          validator: validateEmail),
                      const SizedBox(height: 10),
                      buildTextField("Level (Optional)", levelController ?? TextEditingController(), false,
                          validator: validateLevel),
                      const SizedBox(height: 10),
                      buildTextField("Password", passwordController, true,
                          validator: validatePassword),
                      const SizedBox(height: 10),
                      buildTextField(
                          "Confirm Password", confirmPasswordController, true,
                          validator: validateConfirmPassword),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var existingStudent = box.get(idController.text);
                              if (existingStudent != null) {
                                showSnackbar("Email already exists!");
                                return;
                              }
                              Student student = Student(
                                email: emailController.text,
                                password: passwordController.text,
                                level: levelController?.text ?? "",
                                gender: gender,
                                name: nameController.text,
                                id: idController.text,
                              );
                              await box.put(idController.text, student);
                              showSnackbar("Sign up Successful!");
                              navigateToLogin();
                            } else {
                              showSnackbar("Please, enter all required fields");
                            }
                          },
                          child: const Text("Sign up"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: navigateToLogin,
                            child: const Text("Sign in"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildTextField(
    String hint,
    TextEditingController controller,
    bool isPassword, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword
          ? (controller == passwordController ? obscure : obscureConfirm)
          : false,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    if (controller == passwordController) {
                      obscure = !obscure;
                    } else {
                      obscureConfirm = !obscureConfirm;
                    }
                  });
                },
                icon: Icon(controller == passwordController
                    ? (obscure ? Icons.visibility_off : Icons.visibility)
                    : (obscureConfirm
                        ? Icons.visibility_off
                        : Icons.visibility)),
              )
            : null,
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return "This field is required";
    }
    if (!RegExp(r'^[0-9]+@stud\.fci-cu\.edu\.eg$').hasMatch(value!)) {
      return "Invalid email format. Example: studentID@stud.fci-cu.edu.eg";
    }
    if (value.split('@')[0] != idController.text) {
      return "Email ID must match with your ID";
    }
    return null;
  }

  String? validateLevel(String? value) {
    if (value != null &&
        value.isNotEmpty &&
        !RegExp(r'^[1-4]$').hasMatch(value)) {
      return "Select your level from 1 to 4";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return "This field is required";
    }
    if (!RegExp(r'^(?=.*[0-9]).{8,}$').hasMatch(value!)) {
      return "Password must contain at least one number and 8 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return "This field is required";
    }
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void navigateToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

Future<void> syncOfflineUsersToFirebase() async {
  for (var student in box.values) {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection("students")
          .doc(student.id)
          .get();

      if (!userDoc.exists) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: student.email!,
          password: student.password!,
        );

        await FirebaseFirestore.instance
            .collection("students")
            .doc(student.id)
            .set({
          'id': student.id,
          'name': student.name,
          'email': student.email,
          'gender': student.gender,
          'level': student.level,
        });

        print("Synced ${student.email} to Firebase");
      } else {
        print("${student.email} already exists in Firebase");
      }
    } catch (e) {
      print("Failed to sync ${student.email}: $e");
    }
  }
}
