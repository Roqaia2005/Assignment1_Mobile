import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:student_registeration/helper.dart';
import 'package:student_registeration/Models/student.dart';
import 'package:student_registeration/screens/home_screen.dart';
import 'package:student_registeration/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

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
                  return "This field is required";
                }
                return null;
              },
              decoration: InputDecoration(
                fillColor: const Color.fromARGB(255, 170, 186, 199),
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
              child: Text("Login"),
              onPressed: () async {
                bool isStudentExists = box.values.any(
                  (s) =>
                      s.email == emailController.text &&
                      s.password == passwordController.text,
                );
                if (isStudentExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sign in Successful!")),
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
                    const SnackBar(content: Text("Invalid credintials")),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text("Sign up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
