import 'package:bookartify/screens/explore_screen.dart';
import 'package:bookartify/screens/home_screen.dart';
import 'package:bookartify/screens/profile_screen.dart';
import 'package:bookartify/screens/search_screen.dart';
import 'package:bookartify/screens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ExploreScreen(),
    UploadScreen(),
    SearchScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      ),
      // body: _pages[_currentIndex],
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
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
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
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

