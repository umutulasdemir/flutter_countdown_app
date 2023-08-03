import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Countdown Timer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? _timer;
  int remainingSec = 30;
  Duration duration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void startCountdown() {
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        if (remainingSec > 0) {
          remainingSec--;
          showNotification('Countdown Timer', 'Remaining: $remainingSec sec');
        } else {
          _timer?.cancel();
          showNotification('Countdown Timer', 'Time is up!');
          //
        }
      });
    });
  }

  Future<void> showNotification(String title, String content) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '12345',
      'Countdown Timer Channel',
      channelDescription: 'Timer channel for countdown process.',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, content, platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Remaining: $remainingSec sec'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                startCountdown();
              },
              child: Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
