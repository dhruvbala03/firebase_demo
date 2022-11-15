import 'package:flutter/material.dart';

class MyTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final bool isPassword;

  const MyTextInput({
    Key? key,
    required this.controller,
    required this.text,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<MyTextInput> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: widget.controller,
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.text,
      ),
    );
  }
}
