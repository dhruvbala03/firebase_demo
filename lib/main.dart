import 'package:firebase_demo/resources/auth.dart';
import 'package:firebase_demo/reusable/my_button.dart';
import 'package:firebase_demo/reusable/my_text_input.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyLoginPage());
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _buttonsEnabled = true;

  bool _isLoggedIn = false;

  final Auth _authInstance = Auth();

  String errorMessage = "";

  Future<void> login() async {
    // disable button
    setState(() {
      _buttonsEnabled = false;
    });
    // attempt sign in
    String res = await _authInstance.authenticateUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    // update UI accordingly
    setState(() {
      if (res == "success") {
        errorMessage = "";
        _isLoggedIn = true;
        _emailController.clear();
        _passwordController.clear();
      } else {
        errorMessage = res;
      }

      _buttonsEnabled = true;
    });
  }

  Future<void> signup() async {
    // disable button
    setState(() {
      _buttonsEnabled = false;
    });
    // attempt registration
    String res = await _authInstance.registerUser(
      name: _nameController.text,
      bio: _bioController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    // update UI accordingly
    if (res == "success") {
      setState(() {
        errorMessage = "";
        _nameController.clear();
        _bioController.clear();
      });
      login();
    } else {
      setState(() {
        errorMessage = res;
        _buttonsEnabled = true;
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Firebase Demo",
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(50),
          alignment: Alignment.center,
          child: Column(
            children: [
              const Text(
                "Firebase Demo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 15),
              MyTextInput(controller: _nameController, text: "Name"),
              const SizedBox(height: 10),
              MyTextInput(controller: _bioController, text: "Bio"),
              const SizedBox(height: 15),
              MyTextInput(controller: _emailController, text: "Email"),
              const SizedBox(height: 10),
              MyTextInput(
                controller: _passwordController,
                text: "Password",
                isPassword: true,
              ),
              const SizedBox(height: 15),
              MyButton(
                text: "Log In",
                onPress: login,
                isEnabled: _buttonsEnabled,
              ),
              const SizedBox(height: 10),
              MyButton(
                text: "Sign Up",
                onPress: signup,
                isEnabled: _buttonsEnabled,
              ),
              const SizedBox(height: 15),
              Text(
                  _isLoggedIn ? ("Hello, " + Auth.currentUser.name + "!") : ""),
              const SizedBox(height: 10),
              Text(_isLoggedIn ? ("Bio: " + Auth.currentUser.bio) : ""),
              const SizedBox(height: 25),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
