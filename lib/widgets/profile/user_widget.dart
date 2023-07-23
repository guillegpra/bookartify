import 'package:bookartify/widgets/profile/user_counter.dart';
import 'package:bookartify/widgets/profile/user_display.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  const UserWidget(
      {Key? key, required this.username, required this.profileImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xff2f2f2f),
                  width: 2.0, // Width of the border
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl) as ImageProvider
                    : AssetImage("images/upload-images-placeholder.png")
                        as ImageProvider,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                UserCounter(name: "Art", number: 26 // TODO: change number
                    ),
                SizedBox(width: 10),
                UserCounter(name: "Followers", number: 89 // TODO: change number
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
