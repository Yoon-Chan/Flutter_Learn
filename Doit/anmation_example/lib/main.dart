import 'package:anmation_example/intro.dart';
import 'package:anmation_example/secondpage.dart';
import 'package:anmation_example/sliverpage.dart';
import 'package:flutter/material.dart';
import 'people.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: IntroPage(),
    );
  }
}

class AnimationApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnimationApp();
}

class _AnimationApp extends State<AnimationApp> {
  List<People> peoples = new List.empty(growable: true);
  int current = 0;
  Color weightColor = Colors.blue;
  double _opacity = 1;

  @override
  void initState() {
    super.initState();

    peoples.add(People('스미스', 180, 92));
    peoples.add(People('메리', 162, 55));
    peoples.add(People('존', 177, 75));
    peoples.add(People('바트', 130, 40));
    peoples.add(People('콘', 194, 140));
    peoples.add(People('디디', 100, 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation Example"),
      ),
      body: Container(
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text("이름 : ${peoples[current].name}"),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 2),
                      curve: Curves.bounceIn,
                      color: Colors.amber,
                      child: Text("키 ${peoples[current].height}"),
                      width: 50,
                      height: peoples[current].height,
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 2),
                      curve: Curves.easeInCubic,
                      color: weightColor,
                      child: Text(
                        "몸무게 ${peoples[current].weight}",
                        textAlign: TextAlign.center,
                      ),
                      width: 50,
                      height: peoples[current].weight,
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 2),
                      curve: Curves.linear,
                      color: Colors.pinkAccent,
                      child: Text(
                        "bmi ${peoples[current].bmi.toString().substring(0, 2)}",
                        textAlign: TextAlign.center,
                      ),
                      width: 50,
                      height: peoples[current].bmi,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
                height: 200,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (current < peoples.length - 1) {
                      current++;
                    }

                    _changeWeightColor(peoples[current].weight);
                  });
                },
                child: Text('다음')),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (current > 0) {
                      current--;
                    }

                    _changeWeightColor(peoples[current].weight);
                  });
                },
                child: Text('이전')),

            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _opacity == 1 ? _opacity = 0 : _opacity = 1;
                  });
                },
                child: Text('사라지기')),

            ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondPage(),));
                  });
                },
                child: SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      Hero(tag: 'detail', child: Icon(Icons.cake)),
                      Text('이동하기'),
                    ],
                  ),
                ),
            ),

            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SliverPage(),));
                },
                child: Text('페이지 이동')),


          ],


          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  void _changeWeightColor(double weight) {
    if (weight < 40) {
      weightColor = Colors.blueAccent;
    } else if (weight < 60) {
      weightColor = Colors.indigo;
    } else if (weight < 80) {
      weightColor = Colors.orange;
    } else {
      weightColor = Colors.red;
    }
  }
}
