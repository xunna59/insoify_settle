import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import 'login_form_widget.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                            ' Sign In',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: onboardcaptionsSize,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Login to your account to continue',
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

              const SizedBox(height: 10),

              // Set your desired background color
              const SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: LoginForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
