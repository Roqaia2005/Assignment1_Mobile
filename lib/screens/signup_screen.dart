import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_registeration/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_registeration/models/student.dart';
import 'package:student_registeration/screens/login_screen.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:async';

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
  final levelController = TextEditingController();

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
          await syncOnlineUsersToHive();
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
                              value: 'male',
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
                              value: 'female',
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
                      buildTextField(
                        "Email",
                        emailController,
                        false,
                        validator: (value) {
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
                        },
                      ),
                      const SizedBox(height: 10),
                      buildTextField("Level (Optional)", levelController, false),
                      const SizedBox(height: 10),
                      buildTextField("Password", passwordController, true),
                      const SizedBox(height: 10),
                      buildTextField("Confirm Password", confirmPasswordController, true),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool connected = await InternetConnection().hasInternetAccess;
                              if (!connected) {
                                Student student = Student(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  level: levelController.text,
                                  gender: gender,
                                  name: nameController.text,
                                  id: idController.text,
                                );
                                await box.put(idController.text, student);
                                showSnackbar("Sign up Successful!");
                                navigateToLogin();
                              } else {
                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  await FirebaseFirestore.instance
                                      .collection("students")
                                      .doc(idController.text)
                                      .set({
                                    'id': idController.text,
                                    'name': nameController.text,
                                    'email': emailController.text,
                                    'gender': gender,
                                    'level': levelController.text,
                                  });
                                  showSnackbar("Successfully registered");
                                  navigateToLogin();
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    showSnackbar("Password is too weak");
                                  } else if (e.code == 'email-already-in-use') {
                                    showSnackbar("This email already exists");
                                  } else {
                                    showSnackbar("The email is not valid");
                                  }
                                }
                              }
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
      obscureText: isPassword,
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
                    : (obscureConfirm ? Icons.visibility_off : Icons.visibility)),
              )
            : null,
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void navigateToLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

// this function used when user sign up offline , so when internet connection restored data stored in firebase
Future<void> syncOfflineUsersToFirebase() async {
  for (var student in box.values) {
    try {
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
    } catch (e) {
      print("Failed to sync ${student.email}: $e");
    }
  }
}

Future<void> syncOnlineUsersToHive() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("students").get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      Student student = Student(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        gender: data['gender'],
        level: data['level'],
      );

      if (!box.containsKey(student.id)) {
        await box.put(student.id, student);
        print("Synced ${student.email} to Hive");
      }
    }

    print("Successfully synced all online users to Hive");
  } catch (e) {
    print("Failed to sync online users to Hive: $e");
  }
}
