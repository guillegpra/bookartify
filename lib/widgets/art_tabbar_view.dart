//TABBAR WITH ANIMATION
import 'package:bookartify/widgets/synopsis_widget.dart';
import 'package:bookartify/widgets/tabbar_texts.dart';
import 'package:flutter/material.dart';
import 'package:bookartify/data/dummy_synopsis_data.dart';
import 'art_gridview.dart';

class ArtTabView extends StatefulWidget {
  const ArtTabView({Key? key}) : super(key: key);

  @override
  _ArtTabViewState createState() => _ArtTabViewState();
}

class _ArtTabViewState extends State<ArtTabView> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? widget) {
                return TabBar(
                  controller: _controller,
                  indicatorColor:const Color.fromARGB(255, 192, 162, 73),
                  tabs: [
                    CustomTab(text: "Synopsis", isSelected: _controller.index == 0),
                    CustomTab(text: "Book Art", isSelected: _controller.index == 1),
                    CustomTab(text: "Covers", isSelected: _controller.index == 2),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                SynopsisWidget(synopsis: synopsisData),
                const ArtGridView(),
                const ArtGridView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



//TABBAR WITHOUT ANIMATION
// import 'package:bookartify/widgets/synopsis_widget.dart';
// import 'package:bookartify/widgets/tabbar_texts.dart';
// import 'package:flutter/material.dart';
// import 'package:bookartify/data/dummy_synopsis_data.dart';
// import 'art_gridview.dart';

// class ArtTabView extends StatefulWidget {
//   const ArtTabView({Key? key}) : super(key: key);

//   @override
//   _ArtTabViewState createState() => _ArtTabViewState();
// }

// class _ArtTabViewState extends State<ArtTabView> with SingleTickerProviderStateMixin {
//   late TabController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Material(
//             color: Colors.transparent,
//             child: TabBar(
//               controller: _controller,
//               tabs: const [
//                 CustomTab(text:"Synopsis", isSelected: _controller.index == 0,),
//                 CustomTab(text:"Book Art"),
//                 CustomTab(text:"Covers"),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _controller,
//               children: [
//                 SynopsisWidget(synopsis: synopsisData),
//                 const ArtGridView(),
//                 const ArtGridView(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }