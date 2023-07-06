import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen2 extends StatefulWidget {
  const ProfileScreen2({super.key});

  @override
  State<ProfileScreen2> createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2> {
  double get randHeight => Random().nextInt(100).toDouble();

  List<Widget> _randomChildren = [];

  List<Widget> _randomHeightWidgets(BuildContext context) {
    _randomChildren = List.generate(3, (index) {
      final height = randHeight.clamp(
        50.0,
        MediaQuery.of(context).size.width,
      );
      return Container(
        color: Colors.primaries[index],
        height: height,
        child: Text("Random Height Child ${index + 1}"),
      );
    });

    return _randomChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Persistent AppBar that never scrolls
      appBar: AppBar(
        title: Text("AppBar"),
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          // allows you to build a list of elements that would be scrolled away till the
          // body reached the top
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                  delegate: SliverChildListDelegate(
                    _randomHeightWidgets(context),
                  )
              )
            ];
          },
          body: Column(
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(text: "A",),
                  Tab(text: "B",)
                ],
              ),
              Expanded(
                  child: TabBarView(
                    children: [
                      GridView.count(
                        padding: EdgeInsets.zero,
                        crossAxisCount: 3,
                        children: Colors.primaries.map((color) {
                          return Container(color: color, height: 150.0,);
                        }).toList(),
                      ),
                      ListView(
                        padding: EdgeInsets.zero,
                        children: Colors.primaries.map((color) {
                          return Container(color: color, height: 150.0,);
                        }).toList(),
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
