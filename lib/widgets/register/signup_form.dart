import 'package:bookartify/services/register.dart';
import 'package:bookartify/widgets/register/password_form_field.dart';
import 'package:bookartify/widgets/register/register_button.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _username = "";
  String _password = "";
  String _confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /* -------- Email -------- */
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  fillColor: const Color(0xFFF5EFE1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                  )
              ),
              validator: (value) {
                // if it empty
                if (value?.isEmpty ?? true) {
                  return "Please, enter your email.";
                }

                // if is a valid email address
                if (value != null && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return "Please, enter a valid email address.";
                }

                return null;
              },
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
          ),
          /* -------- Username -------- */
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "Choose a username",
                  fillColor: const Color(0xFFF5EFE1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                  )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please, choose a username";
                }
                if (!RegExp(r"^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$")
                    .hasMatch(value)) {
                  return "Username must be between 3 and 20 characters and can only contain alphanumeric characters, underscore and dot.";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
            ),
          ),
          /* -------- Password -------- */
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: PasswordFormField(
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            )
          ),
          /* -------- Confirm password -------- */
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: PasswordFormField(
              onChanged: (value) {
                setState(() {
                  _confirmPassword = value;
                });
              },
            ),
          ),
          /* -------- Button -------- */
          Container(
            margin: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            width: double.infinity,
            child: RegisterButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Perform the login operation or handle form submission
                  signUp(context, _email, _password, _username);
                }
              },
              buttonText: "Create an account",
            ),
          )
        ],
      )
    );
  }
}

