import 'package:bookartify/services/usernames_db.dart';
import 'package:bookartify/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsernamePage extends StatefulWidget {
  const UsernamePage({super.key});

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Choose a username for your page",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSerifDisplay(
                  fontSize: 26
              ),
            ),
            const SizedBox(height: 18.0,),
            TextFormField(
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
            const SizedBox(height: 18.0,),
            ElevatedButton(
                onPressed: () async {
                  if (!(await usernameAvailable(_username))) {
                    Utils.showSnackBar("Username is already taken", true);
                    return;
                  }

                  User? user = FirebaseAuth.instance.currentUser;
                  // add username to database
                  await addUsername(user!.uid, _username);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F2F2F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  textStyle: GoogleFonts.dmSerifDisplay(
                    fontSize: 18,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Reset password",
                    style: TextStyle(
                        color: Color(0xFFFBF8F2)
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}

