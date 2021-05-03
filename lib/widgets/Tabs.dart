import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qoutes_app/screens/Categories.dart';
import 'package:qoutes_app/screens/FavQuotePage.dart';
import 'package:qoutes_app/screens/Generator.dart';
import 'package:qoutes_app/screens/Home.dart';
import 'package:qoutes_app/utils/Customcolors.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Widget> pages = [HomePage(), Categories(), FavQuotePage(), Generator()];
  PageController pageController = PageController();
  int index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          elevation: 0,
          backgroundColor: Customcolors.green,
          title: new Text(
            "Okey Quotes",
            style: TextStyle(fontFamily: 'Libre Baskerville'),
          ),
          bottom: TabBar(
              onTap: (value) {
                setState(() {
                  index = value;
                  pageController.jumpToPage(index);
                  // print(index);
                });
              },
              unselectedLabelColor: Colors.white60,
              labelColor: Colors.white,
              physics: ScrollPhysics(),
              tabs: [
                new Tab(icon: new Icon(Icons.home), text: 'Home'),
                new Tab(icon: new Icon(Icons.category), text: 'Categries'),
                new Tab(icon: new Icon(Icons.favorite_rounded), text: 'Liked'),
                new Tab(icon: new Icon(Icons.create), text: 'Create'),
              ],
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.all(2)),
          bottomOpacity: 1,
        ),
        body: PageView(
          onPageChanged: (v) {
            print(v);
            setState(() {
              _tabController.animateTo(v);
            });
          },
          controller: pageController,
          children: pages,
        ),
      ),
    );
  }
}
