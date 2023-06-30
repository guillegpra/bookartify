import 'package:bookartify/widgets/image_grid.dart';
import 'package:flutter/material.dart';

class ProfileTabs extends StatefulWidget {
  @override
  _ProfileTabsState createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProfileTabs> {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const placeholderContent = ImageGrid(
      imagePaths: [
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
      ],
      imageTitles: [
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
      ],
    );

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF8A6245),
          // labelStyle: GoogleFonts.poppins(),
          tabs: [
            Tab(text: 'Bookart'),
            Tab(text: 'Covers'),
            Tab(text: 'Collections'),
          ]
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // ------ Bookart content ------
              KeepAliveWrapper(
                key: ValueKey(0),
                child: placeholderContent
              ),
              // ------ Covers content ------
              KeepAliveWrapper(
                key: ValueKey(1),
                child: placeholderContent
              ),
              // ------ Collections content ------
              KeepAliveWrapper(
                key: ValueKey(2),
                child: placeholderContent
              ),
            ],
          )
        )
      ],
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({required this.child, Key? key}) : super(key: key);

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build(context) to maintain the state

    return widget.child;
  }
}
