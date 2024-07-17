import 'package:flutter/material.dart';
import '../../models/notifications_data.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 1,
            shadowColor: Colors.grey[200],
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              leading: Icon(
                notification.iconData,
                color: notification.color,
                size: 25.0,
              ),
              title: Text(
                notification.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 15.0,
                      ),
                      Text(
                        ' ${notification.time.year}/${notification.time.month}/${notification.time.day} - ${notification.time.hour}:${notification.time.minute}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
