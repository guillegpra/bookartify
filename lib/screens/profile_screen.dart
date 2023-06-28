import 'package:bookartify/widgets/profile_tabs.dart';
import 'package:bookartify/widgets/user_counter.dart';
import 'package:bookartify/widgets/user_info.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    // backgroundImage: AssetImage("..."),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      UserCounter(
                        name: "Art",
                        number: 26 // TODO: change number
                      ),
                      SizedBox(width: 10),
                      UserCounter(
                        name: "Followers",
                        number: 89 // TODO: change number
                      )
                    ],
                  )
                ],
              ),
              UserInfo()
            ],
          ),
          SizedBox(height: 5),
          Expanded(child: ProfileTabs())
        ],
      )
    );
  }
}
