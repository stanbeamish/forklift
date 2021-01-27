import 'package:flutter/material.dart';
import 'package:forklift/components/explain_app.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

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
            Navigator.pushNamed(context, '/simplemove');
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
