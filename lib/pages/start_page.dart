import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:forklift/pages/register_page.dart';
import 'package:forklift/pages/finger_move_page.dart';
import 'package:forklift/utils/basic_logger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:forklift/components/explain_app.dart';
import 'package:forklift/pages/simple_movement_page.dart';
import 'package:forklift/utils/screen_arguments.dart';

class StartPage extends StatefulWidget {
  static const StartPageRoute = '/start';

  final cameras;
  StartPage(this.cameras, {Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'A forklift - CNN animated on the command of your fingers',
            style: GoogleFonts.heebo(fontStyle: FontStyle.normal),
          ),
        ),
        backgroundColor: Colors.white,
        body: ExplainApp(),
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.floating,
          padding: EdgeInsets.all(12),
          snakeShape: SnakeShape.circle,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedLabelStyle: const TextStyle(fontSize: 20),
          unselectedLabelStyle: const TextStyle(fontSize: 20),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            BasicLogger.log("_build", "$index called");
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.outbond_outlined), label: 'Schaltfläche'),
            BottomNavigationBarItem(
                icon: Icon(Icons.how_to_reg_outlined), label: 'Anmelden'),
            BottomNavigationBarItem(
                icon: Icon(Icons.outbond_outlined), label: 'Tflite CNN'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            switch (_selectedIndex) {
              case 0:
                Navigator.pushNamed(
                  context,
                  SimpleMovementPage.SimpleMovementPageRoute,
                  arguments: ScreenArguments(widget.cameras),
                );
                break;
              case 1:
                Navigator.pushNamed(
                  context,
                  RegisterPage.RegisterPageRoute,
                  arguments: ScreenArguments(widget.cameras),
                );
                break;
              case 2:
                Navigator.pushNamed(
                  context,
                  FingerMovePage.FingerMovePageRoute,
                  arguments: ScreenArguments(widget.cameras),
                );
                break;
            }
          },
          label: Text('Let\'s Go'),
          icon: Icon(Icons.fingerprint_outlined),
        ),
      ),
    );
  }
}
