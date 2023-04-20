import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required TextEditingController controller,
    required this.label,
  }) : _controller = controller;

  final TextEditingController _controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        textAlign: TextAlign.start,
        obscureText: label == 'Password' ? true : false,
        autofocus: true,
        controller: _controller,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}