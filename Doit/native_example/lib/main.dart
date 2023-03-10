import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_example/sendDataExample.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      //운영체제가 iOS 이면 실행
      return CupertinoApp(
        home: CupertinoNativeApp(),
      );
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SendDataExample()//NativeApp(),
      );
    }
  }
}


class CupertinoNativeApp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _NativeApp();
}

class NativeApp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _NativeApp();
}


class _NativeApp extends State<NativeApp>{

  static const platform = const MethodChannel('com.flutter.dev/info');
  String _deviceInfo = 'Unknown info';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Native 통신 예제'),
      ),

      body:  Container(
        child: Center(
          child: Text(
            _deviceInfo,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getDeviceInfo();
        },
        child: Icon(Icons.get_app),
      ),
    );
  }


  Future<void> _getDeviceInfo() async {
    String deviceInfo;
    try{
      final String result = await platform.invokeMethod('getDeviceInfo');
      deviceInfo = 'Device info : $result';


    }on PlatformException catch(e) {
      deviceInfo = 'Failed to get Device info : ${e.message}';
    }

    setState(() {
      _deviceInfo = deviceInfo;
    });
  }
}