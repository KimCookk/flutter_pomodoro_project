import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_prototype/view/pomodoro_view.dart'; // 플랫폼 확인을 위한 import

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 플랫폼별 초기화 설정
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('app_icon');

  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        debugPrint('Notification payload: ${response.payload}');
      }
    },
  );

  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}

// iOS에서 알림을 수신할 때 처리 (앱이 포그라운드 상태일 때)
Future<void> onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  showDialog(
    context: navigatorKey.currentState!.context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title ?? 'Notification'),
      content: Text(body ?? 'No message'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
