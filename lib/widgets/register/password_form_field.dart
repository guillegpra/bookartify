import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const PasswordFormField({super.key, required this.onChanged});

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter a password",
          fillColor: const Color(0xFFF5EFE1),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility_off : Icons.visibility
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          )
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return "Please, enter a password";
        }
        // Add more password validation if needed
        return null;
      },
      onChanged: widget.onChanged,
    );
  }
}
