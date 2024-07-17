import 'package:flutter/material.dart';

import '../../../../constants/app_constants.dart';
import 'forgot_password_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
                            'Forgot Password',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: onboardcaptionsSize,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Please enter details associated with your account.',
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

              const SizedBox(
                width: double.infinity,
                height: 400,
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: ForgotPasswordForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
