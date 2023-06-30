import 'package:bookartify/widgets/user_counter.dart';
import 'package:bookartify/widgets/user_display.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final String username;

  const UserInfo({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Column(
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
        UserDisplay(
          username: username,
        )
      ],
    );
  }
}
