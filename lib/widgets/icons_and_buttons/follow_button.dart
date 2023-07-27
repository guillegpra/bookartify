import 'package:bookartify/services/database_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowButton extends StatefulWidget {
  final bool isFollowing;
  final String userId;
  
  const FollowButton({super.key, required this.userId,
    required this.isFollowing});

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isFollowing = false;
  
  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }
  
  void _toggleFollowing() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _isFollowing ? await unfollowUser(currentUserId, widget.userId)
        : await followUser(currentUserId, widget.userId);

    setState(() {
      _isFollowing = !_isFollowing;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _toggleFollowing, 
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFollowing ? const Color(0xFFF5EFE1) : const Color(0xFFBFA054),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        )
      ),
      child: Text(
        _isFollowing ? "Following" : "Follow",
        style: GoogleFonts.poppins(
          color: const Color(0xFF2F2F2F)
        ),
      )
    );
  }
}

