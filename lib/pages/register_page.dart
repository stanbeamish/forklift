import 'package:flutter/material.dart';
import 'package:forklift/utils/basic_logger.dart';
import 'dart:math' as math;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  static const RegisterPageRoute = '/basicanimation';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);

    animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.8;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/robot.jpg',
                      ),
                      Center(
                        child: Container(
                          width: 300,
                          padding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 30, right: 30),
                          child: Image.asset(
                            'assets/images/logo_text.png',
                            height: 90,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25))),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 290.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            color: Colors.black.withOpacity(0.2),
                            child: Card(
                              elevation: 12,
                              margin: EdgeInsets.all(1),
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 10),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      child: Image.asset(
                                          'assets/images/logo_cube.png'), //NetworkImage
                                      radius: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _buildInputField(
                                      context,
                                      hintText: 'Ihre E-Mail-Adresse ...',
                                      icon: Icons.email,
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    _buildInputField(
                                      context,
                                      hintText: 'Ihr Kennwort ...',
                                      icon: Icons.security,
                                      obscure: true,
                                    ),
                                    SizedBox(
                                      height: 22,
                                    ),
                                    Column(
                                      children: [
                                        RoundedButton(
                                          onPress: () {},
                                          textColor: Colors.black,
                                          color: Colors.grey.withOpacity(0.3),
                                          text: 'Abbruch',
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        RoundedButton(
                                          onPress: () {
                                            BasicLogger.log(
                                                'build', 'Pressed to Login');
                                          },
                                          color: Colors.blueAccent,
                                          text: 'Anmelden',
                                          textColor: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Sie haben sich noch nicht '),
                                            Text(
                                              'registriert? ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('Klicken Sie '),
                                            InkWell(
                                              onTap: () {},
                                              child: Text(
                                                'hier',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blueAccent),
                                              ),
                                            ),
                                            Text('!'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      {String text, Function onTap, Color fillColor, Color textColor}) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Container(
        height: 45,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Theme.of(context).primaryColor),
          color: fillColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
            ),
          ),
        ),
      ),
      splashColor: Colors.blue,
      highlightColor: Colors.blue,
    );
  }

  Widget _buildInputField(BuildContext context,
      {String hintText, IconData icon, bool obscure = false}) {
    return TextField(
      autocorrect: true,
      obscureText: obscure,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white70,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40.0),
            ),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40.0),
            ),
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2,
            ),
          )),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Color color, textColor;
  final double fontSize;

  const RoundedButton(
      {Key key,
      this.onPress,
      this.text,
      this.color,
      this.textColor,
      this.fontSize = 18})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          onPressed: onPress,
          color: color,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
