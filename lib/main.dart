import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCPSDK Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MCPSDK Flutter Demo'),
      ),
      body:  Center(
        child: Column(
          children: [
            SizedBox(height: 100,),
            ElevatedButton(child: Text("Wallet iOS"), onPressed: () async {
              const iosPlatform = MethodChannel("com.flutter.dev/mcpsdk");
              try {
                print("start");
                final  result = await iosPlatform.invokeMethod('addToWallet');
                print ("------- ------ Result from SDK -------- $result");
              } on PlatformException catch (e) {
                print("Failed : '${e.message}'.");

              }
              print("End");
            },),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          const iosPlatform = MethodChannel("com.flutter.dev/mcpsdk");
          try {
            print("start");
            final  result = await iosPlatform.invokeMethod('startTask');
            print ("------- ------ Result from SDK -------- $result");
          } on PlatformException catch (e) {
            print("Failed : '${e.message}'.");

          }
          print("End");
        },
        tooltip: 'Increment',
        child: const Text("Start Task"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
