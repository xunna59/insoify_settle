import 'package:flutter/material.dart';

import '../../../../constants/app_constants.dart';
import 'reset_password_widget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key, required this.phone}) : super(key: key);
  final String phone;
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String userPhone = ''; // Declare a variable to store the phone number

  @override
  void initState() {
    super.initState();
    userPhone =
        widget.phone; // Assign the phone number to the variable in initState
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sign In section
              Container(
                height: 200,
                width: double.infinity,
                color: Theme.of(context)
                    .colorScheme
                    .secondary, // Set your desired background color
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      color: Theme.of(context).colorScheme.primary,
                      icon: const Icon(Icons.arrow_circle_left_outlined),
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: onboardcaptionsSize,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Enter a new password for your account. ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: onboardsubCaptions,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Form section

              // Set your desired background color
              SizedBox(
                width: double.infinity,
                height: 800,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ResetPasswordForm(userPhone: userPhone),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
