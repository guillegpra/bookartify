import 'package:bookartify/widgets/register_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.dmSerifDisplayTextTheme()
      ),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      fillColor: Color(0xFFF5EFE1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none
                      )
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please, enter your email";
                    }
                    // Add more email validation if needed
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      fillColor: const Color(0xFFF5EFE1),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                      )
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please, enter your password";
                    }
                    // Add more password validation if needed
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: RegisterButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Perform the login operation or handle form submission
                      // You can access _email and _password variables here
                    }
                  },
                  buttonText: "Login",
                ),
              )
            ],
          )
      ),
    );
  }
}
