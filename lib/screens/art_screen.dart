import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArtScreen extends StatelessWidget {
  const ArtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Book title",
          style: GoogleFonts.dmSerifDisplay(
              fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)
        ),
      ),
      body: Center(
        child: Text(
          "Art Screen",
          style: GoogleFonts.poppins(
              fontSize: 24
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.poppinsTextTheme()
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFFF4F1EA),
          selectedItemColor: Color(0xFFBFA054),
          unselectedItemColor: Color(0xFF372213),
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: "Explore"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "Upload"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile"
            ),
          ],
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
