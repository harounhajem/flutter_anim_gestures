import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestures Animations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  Animation<double> animation;
  AnimationController animationController;

  int numTaps = 0, numDoubleTaps = 0, numLongPress = 0;
  double posX = 0.0, posY = 0.0, boxSize = 0, fullBoxSize = 150.0;
  bool isAnimatingForward = true;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 850), vsync: this);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animation.addListener(() {
      setState(() {
        boxSize = animation.value.toDouble() * fullBoxSize;
        setCenter(context);
      });
    });
    animationController.forward();
  }


  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (posX == 0) {
      setCenter(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestures and Animations"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.toll),
          onPressed: (){

        if (isAnimatingForward) {
         animationController.reverse();
        }else{
          animationController.forward();
        }
        isAnimatingForward = !isAnimatingForward;

      }
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Center(
              heightFactor: 1,
              child: Text(
                  "Taps: $numTaps - Double taps: $numDoubleTaps - Longpress: $numLongPress",
                  style: TextStyle(color: Colors.black, fontSize: 18))),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            numTaps++;
          });
        },
        onDoubleTap: () {
          setState(() {
            numDoubleTaps++;
          });
        },
        onLongPress: () {
          setState(() {
            numLongPress++;
          });
        },
        onVerticalDragUpdate: (DragUpdateDetails value) {
          setState(() {
            double delta = value.delta.dy;
            posY += delta;
          });
        },
        onHorizontalDragUpdate: (DragUpdateDetails value) {
          setState(() {
            double delta = value.delta.dx;
            posX += delta;
          });
        },
        child: Stack(
          children: <Widget>[
            Positioned(
                top: posY,
                left: posX,
                child: Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: BoxDecoration(color: Colors.orangeAccent),
                ))
          ],
        ),
      ),
    );
  }

  void setCenter(BuildContext context) {
    posX = (MediaQuery.of(context).size.width / 2 - boxSize / 2);
    posY = (MediaQuery.of(context).size.height / 2 -
        boxSize / 2 -
        80 /*Top- and bottom-size*/);
    setState(() {
      posX = posX;
      posY = posY;
    });
  }
}
