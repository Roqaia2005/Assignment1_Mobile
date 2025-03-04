import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:student_registeration/screens/home_screen.dart';
import 'package:student_registeration/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  bool obscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/images/undraw_login_wqkt.png"),
            ),
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "this field is required";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                fillColor: Colors.blue,
                filled: true,
                hintText: "Email",
                hintStyle: const TextStyle(color: Color.fromARGB(153, 0, 0, 0)),
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
                  return "this field is required";
                } else {
                  return null;
                }
              },
              onSaved: (value) {},
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                ),
                filled: true,
                fillColor: Colors.blue,
                hintText: "Password",
                hintStyle: const TextStyle(color: Color.fromARGB(153, 0, 0, 0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String email = emailController.text;
                  String password = passwordController.text;

                  final box = await Hive.openBox('students');
                  final student = box.values.firstWhere(
                    (student) =>
                        student.email == email && student.password == password,
                    orElse: () => null,
                  );

                  if (student != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Successful!")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid Email or Password!"),
                      ),
                    );
                  }
                }
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text("Sign up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
