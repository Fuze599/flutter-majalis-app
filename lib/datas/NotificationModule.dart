import 'package:flutter/material.dart';

class NotificationModule {
  static void getNotification(BuildContext context, String notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.indigo,
        content: Text(notification),
      ),
    );
  }
}