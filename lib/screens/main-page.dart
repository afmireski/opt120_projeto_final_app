import 'package:flutter/material.dart';
import '../components/side-bar.dart';
import '../components/bottom-bar.dart';
import '../components/custom-app-bar.dart';
import 'home-page.dart';
import 'user-page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    UserPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('../images/utfpr_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
          drawer: SideBar(),
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomBar(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
          ),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
