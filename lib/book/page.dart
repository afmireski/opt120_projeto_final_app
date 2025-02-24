import 'package:flutter/material.dart';
import 'package:produto_front/book/form.dart';

class BookScreen extends StatefulWidget {
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/utfpr_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  'images/logo_reservai.png', // Certifique-se de que o caminho está correto
                  width: 200,
                  height: 120,
                ),
              ],
            ),
            backgroundColor: Colors.white.withOpacity(0.6),
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            elevation: 4.0,
            shadowColor: Colors.grey.withOpacity(0.5),
          ),
          body: Padding(
            padding: EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: ColoredBox(
                color: Colors.white,
                child: BookForm(),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
