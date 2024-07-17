import 'package:flutter/material.dart';
import '../../../../../settle_iapi.dart';
import '../../../../services/notification_service.dart';
import '../account_settings/account_security.dart';
import '../account_settings/account_settings.dart';

import '../contact_us/contact_us.dart';
import '../notifications/notifications.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool hasNewNotification = true;
  String fullName = '';

  late final LocalNotificationService service;
  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
    userDashboard();
  }

  var siapi = SettleIAPI();

  void _logout() async {
    await siapi.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> userDashboard() async {
    try {
      if (!siapi.isAuthorized) {
        throw UnauthorizedRequestException();
      }

      Map dashboard = await siapi.fetchProfile();

      setState(() {
        fullName = dashboard['fullname'];
      });
    } on NetworkErrorException {
      print('Network error occurred. Please check your internet connection.');
    } on InvalidResponseException {
      print('Server error. Try again later.');
    } on ServerErrorException catch (e) {
      print('Server error: ${e.message}');
    } on UnauthorizedRequestException {
      print('Unauthorized request. Please log in.');
      // Handle unauthorized request, e.g., navigate to the login screen
    } catch (e, s) {
      print('An unknown error occurred.');

      //! console only
      print(e);
      print(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'My Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                fullName,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      if (hasNewNotification)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: const Text(
                              '•',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      foregroundColor: Theme.of(context).colorScheme.secondary),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountSettingsScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      foregroundColor: Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountSecurityScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Security',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      foregroundColor: Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.phone_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Contact us',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      foregroundColor: Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _logout();
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                    color: Colors.red[900],
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      foregroundColor: Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: OutlinedButton.icon(
              //     onPressed: () async {
              //       await service.showNotification(
              //           id: 0, title: 'Notification title', body: 'some body');
              //     },
              //     icon: Icon(
              //       Icons.notification_add_outlined,
              //       color: Colors.red[900],
              //     ),
              //     label: Align(
              //       alignment: Alignment.centerLeft,
              //       child: Text(
              //         'Show Notification',
              //         style: TextStyle(
              //           color: Colors.red[900],
              //         ),
              //       ),
              //     ),
              //     style: OutlinedButton.styleFrom(
              //         padding: const EdgeInsets.all(15),
              //         foregroundColor: Theme.of(context).colorScheme.secondary),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
