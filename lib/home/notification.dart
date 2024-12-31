import 'package:flutter/material.dart';
import '../provider/user_provider.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final notifications = userProvider.notifications;
          
          if (notifications.isEmpty) {
            return const Center(
              child: Text('No notifications yet'),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Dismissible(
                key: Key(index.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  userProvider.clearNotification(index);
                },
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(Icons.rate_review, color: Colors.white),
                  ),
                  title: Text(notification['title']),
                  subtitle: Text(notification['message']),
                  trailing: notification['isRead'] 
                    ? null 
                    : const CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.orangeAccent,
                      ),
                  onTap: () {
                    userProvider.markNotificationAsRead(index);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}