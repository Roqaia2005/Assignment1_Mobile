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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/images/undraw_login_wqkt.png"),
              ),
              TextFormField(
                controller: idController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "This field is required";
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value!)) {
                    return "ID must be numeric";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "ID",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(153, 0, 0, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "This field is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(153, 0, 0, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
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
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "This field is required";
                  }
                  if (!RegExp(
                    r'^[0-9]+@stud\.fci-cu\.edu\.eg$',
                  ).hasMatch(value!)) {
                    return "Invalid email format. Example: studentID@stud.fci-cu.edu.eg";
                  }
                  if (value.split('@')[0] != idController.text) {
                    return "Email ID must match with your ID";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(153, 0, 0, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "This field is required";
                  }
                  if (!RegExp(r'^[1-4]').hasMatch(value!)) {
                    return "Select your level from 1 to 4";
                  }

                  return null;
                },
                controller: levelController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Level (Optional)",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(153, 0, 0, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: obscure,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "This field is required";
                  }

                  if (!RegExp(r'^(?=.*[0-9]).{8,}$').hasMatch(value!)) {
                    return "Password must contain at least one number and 8 characters";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),

                  hintText: "Password",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(153, 0, 0, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "This field is required";
                  }
                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () async {
                      setState(() {
                        obscureConfirm = !obscureConfirm;
                      });
                    },
                    icon: Icon(
                      obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),

                  hintText: "Confirm Password",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(153, 0, 0, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool connected =
                        await InternetConnection().hasInternetAccess;
                    if (!connected) {
                      // if not connected sign up with hive local database

                      Student student = Student(
                        email: emailController.text,
                        password: passwordController.text,
                        level: levelController.text,
                        gender: gender,
                        name: nameController.text,
                        id: idController.text,
                      );
                      await box.put(idController.text, student);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sign up Successful!")),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    } else {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
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

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Successfully registered"),
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password is too weak"),
                            ),
                          );
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("This email already exists"),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("The email is not valid"),
                            ),
                          );
                        }
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please, enter all required fields"),
                      ),
                    );
                  }
                },
                child: const Text("Sign up"),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text("Sign in"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// this function used when user sign up offline , so when internet connection restored data stored in firebase
Future<void> syncOfflineUsersToFirebase() async {
  for (var student in box.values) {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
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
