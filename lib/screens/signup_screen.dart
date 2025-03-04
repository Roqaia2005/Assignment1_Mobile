import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:student_registeration/Models/student.dart';
import 'package:student_registeration/screens/login_screen.dart';

Map<String, dynamic> users = {};

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
  bool obscure = true;
  final _formKey = GlobalKey<FormState>();
  _SignupScreenState() {
    Student newStudent = Student(
      id: idController.text,
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      level: levelController.text,
      gender: gender!,
    );
    var studentBox = Hive.box<Student>('students');
    studentBox.add(newStudent);
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
                  fillColor: Colors.blue,
                  filled: true,
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
                  fillColor: Colors.blue,
                  filled: true,
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
                  fillColor: Colors.blue,
                  filled: true,
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
                controller: levelController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.blue,
                  filled: true,
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
                  filled: true,
                  fillColor: Colors.blue,
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
                obscureText: obscure,
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
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.blue,
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      users[emailController.text] = passwordController.text;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Sign up Successful!")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
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
                          builder: (context) {
                            return LoginScreen();
                          },
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
