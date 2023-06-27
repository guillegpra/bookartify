import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            letterSpacing: -0.7
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
          onPressed: () {
            // Handle more options button
          },
          icon: Icon(Icons.more_vert)
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    // backgroundImage: AssetImage("..."),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text("Art"),
                          Text("34") // TODO: change number
                        ],
                      ),
                      Column(
                        children: [
                          Text("Followers"),
                          Text("78") // TODO: change number
                        ],
                      )
                    ],
                  )
                ],
              ),
              Text("username")
            ],
          )
        ],
      )
    );
  }
}
