import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String message;
  final DateTime time;
  final IconData iconData;
  final Color color;
  final String status;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.iconData,
    required this.color,
    required this.status,
  });
}

List<NotificationItem> notifications = [
  NotificationItem(
    title: 'Complete account verification',
    message: 'Complete account verification to increase transaction limit',
    time: DateTime(2023, 9, 14, 10, 15),
    iconData: Icons.warning,
    color: Colors.yellow.shade600,
    status: 'Pending',
  ),
];
