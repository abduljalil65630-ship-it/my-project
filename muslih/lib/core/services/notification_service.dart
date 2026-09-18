import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final SupabaseClient _client;
  NotificationService(this._client);

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  /// تهيئة نظام التنبيهات
  Future<void> initialize() async {
    // 1. طلب الصلاحيات
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. إعداد التنبيهات المحلية للأندرويد
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    
    await _localNotifications.initialize(initializationSettings);

    // 3. الاستماع للتنبيهات أثناء فتح التطبيق
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // 4. تحديث الـ Token في قاعدة البيانات
    await _updatePushToken();
  }

  Future<void> _updatePushToken() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final token = await _fcm.getToken();
    if (token != null) {
      await _client.from('profiles').update({'push_token': token}).eq('id', user.id);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await _localNotifications.show(
      0,
      message.notification?.title ?? 'تنبيه جديد',
      message.notification?.body ?? '',
      platformChannelSpecifics,
    );
  }
}
