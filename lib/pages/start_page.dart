import 'package:flutter/material.dart';
import 'package:forklift/components/explain_app.dart';
import 'package:forklift/pages/simple_movement_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:forklift/utils/screen_arguments.dart';

class StartPage extends StatefulWidget {
  final cameras;
  StartPage(this.cameras, {Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(
              context,
              SimpleMovementPage.SimpleMovementPageRoute,
              arguments: ScreenArguments(widget.cameras),
            );
          },
          label: Text('Auf Gehts'),
          icon: Icon(Icons.fingerprint_outlined),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'A forklift - CNN animated on the command of your fingers',
            style: GoogleFonts.heebo(fontStyle: FontStyle.normal),
          ),
        ),
        body: ExplainApp(),
      ),
    );
  }
}
