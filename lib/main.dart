import 'package:flutter/material.dart';
import 'components/side-bar.dart';
import 'components/bottom-bar.dart';
import 'components/custom-app-bar.dart';
import 'screens/home-page.dart';
import 'screens/user-page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva Ai!',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
     return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('../images/utfpr_background.png'), // Substitua pelo caminho correto
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
          backgroundColor: Colors.transparent, // Deixe o Scaffold transparente
        ),
      ],
    );
  }
}
