import 'package:bookartify/screens/explore_screen.dart';
import 'package:bookartify/screens/home_screen.dart';
import 'package:bookartify/screens/profile_screen.dart';
import 'package:bookartify/screens/search_screen.dart';
import 'package:bookartify/screens/upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // -------------- User info --------------
  final User user = FirebaseAuth.instance.currentUser!;

  // -------------- Navigation bar --------------
  int _currentIndex = 0;

  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>(),
  };

  final List<Widget> _pages = <Widget> [
    HomeScreen(),
    ExploreScreen(),
    UploadScreen(),
    // BookScreen(),
    ProfileScreen(userId: FirebaseAuth.instance.currentUser!.uid,)
  ];

  // buildNavigator() {
  //   return Navigator(
  //     key: navigatorKeys[_currentIndex],
  //     onGenerateRoute: (RouteSettings settings) {
  //       return MaterialPageRoute(builder: (_) => _pages.elementAt(_currentIndex));
  //     },
  //   );
  // }

  final List<Widget> _navPages = <Widget> [
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      }
    ),
    Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (_) => const ExploreScreen());
        }
    ),
    Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (_) => const UploadScreen());
        }
    ),
    Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (_) => const SearchScreen());
        }
    ),
    Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (_) => ProfileScreen(userId: FirebaseAuth.instance.currentUser!.uid,));
        }
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _navPages,
      ),
      // body: buildNavigator(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme()
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFF4F1EA),
          selectedItemColor: const Color(0xFFBFA054),
          unselectedItemColor: const Color(0xFF372213),
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
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}

