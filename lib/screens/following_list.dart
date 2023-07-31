import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowingListScreen extends StatefulWidget {
  @override
  _FollowingListScreenState createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Following",
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Color(0xFF8A6245),
            tabs: [
              Tab(
                icon: Icon(Icons.book),
                text: "Books",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Artists",
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBooksTab(),
                _buildArtistsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksTab() {
    // Replace this with your books content
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.book),
          title: Text("Book ${index + 1}"),
          subtitle: Text("Author: Author ${index + 1}"),
        );
      },
    );
  }

  Widget _buildArtistsTab() {
    // Replace this with your artists content
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.person),
          title: Text("Artist ${index + 1}"),
        );
      },
    );
  }
}
