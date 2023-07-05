import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScanBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchScanBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Container(
        decoration: BoxDecoration(
            color: Color(0xFFE3D4B5),
            borderRadius: BorderRadius.circular(15)
        ),
        child: TextField(
          style: GoogleFonts.poppins(
              color: Color(0xFF372213)
          ),
          decoration: InputDecoration(
              hintText: "Search by title/author or ISBN",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none
          ),
          onChanged: (value) {
            // Handle search input changes
          },
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              // Handle scan icon press
            },
            icon: Icon(
              Icons.qr_code_scanner,
              color: Color(0xFF372213),
            )
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
