import 'package:bookartify/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InactiveSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController _controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0,
      title: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE3D4B5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _controller,
                enabled: false, // making TextField uneditable
                style: GoogleFonts.poppins(
                  color: const Color(0xFF372213),
                ),
                decoration: const InputDecoration(
                  hintText: "Search by Title, Author or ISBN",
                  prefixIcon: Icon(Icons.search, color: Color(0xFF372213)),
                  border: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                print("QR Code button pressed.");
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.qr_code_scanner, color: Color(0xFF372213)),
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}






