import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScanBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;

  const SearchScanBar({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SearchScanBarState createState() => _SearchScanBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchScanBarState extends State<SearchScanBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(
          () {}); // rebuilds the widget on every text change to update the cross icon visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3D4B5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: _controller,
          style: GoogleFonts.poppins(
            color: const Color(0xFF372213),
          ),
          decoration: InputDecoration(
            hintText: "Search by Title, Author or ISBN",
            prefixIcon: const Icon(Icons.search),
            // If there's text in the TextField, it shows a clear button, otherwise, shows a scan button
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged("");
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    color: const Color(0xFF372213),
                    onPressed: () {
                      // Handles the scan icon press
                    },
                  ),
            border: InputBorder.none,
          ),
          onChanged: widget.onChanged,
          autofocus: true, // TextField automatically focused
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


