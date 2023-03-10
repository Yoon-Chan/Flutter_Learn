import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
      analytics: analytics);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Firebase Example",
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),

        navigatorObservers: [observer],
        home: FirebaseApp(
          analytics: analytics,
          observer: observer,
        ),
    );
  }
}


class FirebaseApp extends StatefulWidget {
  FirebaseApp({Key? key, required this.analytics, required this.observer})
      : super(key: key);


  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  State<StatefulWidget> createState() => _FirebaseAppState(analytics, observer);
}

class _FirebaseAppState extends State<FirebaseApp> {

  _FirebaseAppState(this.analytics, this.observer);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  String _message = "";


  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    // 애널리틱스의 logEvent를 호출해 text_event라는 키값으로 데이터 저장
    await analytics.logEvent(
      name: 'text_event',
      parameters: <String, dynamic>{
        'string': 'hello flutter',
        'int': 100
      },
    );
    setMessage("Analytics 보내기 성공");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Example"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: _sendAnalyticsEvent,
                child: Text('테스트')),
            Text(_message, style: const TextStyle(color: Colors.blueAccent),),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),

      floatingActionButton: FloatingActionButton(child: const Icon(Icons.tab),
        onPressed: () {},),
    );
  }
}


