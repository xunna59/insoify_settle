import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:settle/providers/db_provider.dart';

import '../../../../../settle_iapi.dart';
import '../../../authentication/screens/account_verification/personal/step_three.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  var siapi = SettleIAPI();
  bool _secured = false;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    userDashboard();
    DbProvider().getAuthState().then((value) {
      setState(() {
        _secured = value;
      });
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> userDashboard() async {
    print("\nLoading profile...");
    try {
      if (!siapi.isAuthorized) {
        throw UnauthorizedRequestException();
      }

      Map dashboard = await siapi.fetchProfile();

      setState(() {
        fullNameController.text = dashboard['fullname'];
        emailController.text = dashboard['email'];
        phoneNumberController.text = dashboard['phone'];
        addressController.text = dashboard['address'];
      });

      // hide Activity indicator
      print('\nDone');
    } on NetworkErrorException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Network error occurred. Please check your internet connection.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    } on InvalidResponseException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Server error. Try again later.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    } on ServerErrorException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Server error. Try again later.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    } on UnauthorizedRequestException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Unauthorized request. Please log in.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An unknown error occurred.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    }
  }

  void submitform() async {
    try {
      Map data = {
        'email': emailController.text,
      };

      print(emailController.text);

      await siapi.updateProfile(data, () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Phone Number Updated Successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          elevation: 10,
        ));
      });
    } on NetworkErrorException catch (e) {
      print('Network error:  ${e.message}');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
        backgroundColor: Colors.red,
      ));
    } on InvalidResponseException catch (e) {
      print('Message: ${e.message}');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
        backgroundColor: Colors.red,
      ));
    } on ServerErrorException catch (e) {
      print('Message: ${e.message}');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      //hide Activity indicator
      print('Done');

      //handle all other errors - show UI in appropriate language
      print('An unknown error occured.');
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
              const SizedBox(height: 30.0),
              const Text(
                'Full Name',
                style: TextStyle(fontSize: 16.0),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Add a border
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: fullNameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your full name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        submitform();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Phone Number',
                style: TextStyle(fontSize: 16.0),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Add a border
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: phoneNumberController,
                          enabled: true,
                          decoration: const InputDecoration(
                            hintText: 'Phone number',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () async {
                        // Handle edit action for email
                        try {
                          Map data = {
                            'phone': phoneNumberController,
                          };

                          await siapi.updateProfile(data, () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text('Phone Number Updated Successfully'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(50),
                              elevation: 10,
                            ));
                          });
                        } on NetworkErrorException {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Network error occurred. Please check your internet connection.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));
                        } on InvalidResponseException {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Server error. Try again later.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));
                        } on ServerErrorException catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Server error. Try again later.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));
                        } on UnauthorizedRequestException {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('Unauthorized request. Please log in.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));

                          // Handle unauthorized request, e.g., navigate to the login screen
                        } catch (e, s) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('An unknown error occurred.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));

                          //! console only
                          print(e);
                          print(s);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Email',
                style: TextStyle(fontSize: 16.0),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Add a border
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () async {
                        // Handle edit action for email
                        try {
                          Map data = {
                            'email': emailController,
                          };

                          await siapi.updateProfile(data, () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Email Updated Successfully'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(50),
                              elevation: 10,
                            ));
                          });
                        } on NetworkErrorException {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Network error occurred. Please check your internet connection.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));
                        } on InvalidResponseException {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Server error. Try again later.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));
                        } on ServerErrorException catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Server error. Try again later.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));
                        } on UnauthorizedRequestException {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('Unauthorized request. Please log in.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));

                          // Handle unauthorized request, e.g., navigate to the login screen
                        } catch (e, s) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('An unknown error occurred.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));

                          //! console only
                          print(e);
                          print(s);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Address',
                style: TextStyle(fontSize: 16.0),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Add a border
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () async {
                        // Handle edit action for email
                        try {
                          Map data = {
                            'address': addressController,
                          };

                          await siapi.updateProfile(data, () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Address Updated Successfully'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(50),
                              elevation: 10,
                            ));
                          });
                        } on NetworkErrorException {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Network error occurred. Please check your internet connection.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));
                        } on InvalidResponseException {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Server error. Try again later.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));
                        } on ServerErrorException catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Server error. Try again later.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));
                        } on UnauthorizedRequestException {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('Unauthorized request. Please log in.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));

                          // Handle unauthorized request, e.g., navigate to the login screen
                        } catch (e, s) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('An unknown error occurred.'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(50),
                            elevation: 10,
                          ));

                          //! console only
                          print(e);
                          print(s);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enable Fingerprint ID',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Switch(
                    value: _secured,
                    onChanged: (value) async {
                      setState(() {
                        _secured = value;
                      });
                      DbProvider().saveAuthState(value);

                      // If turning on, prompt for biometric authentication
                      if (value) {
                        try {
                          bool authenticated =
                              await _localAuthentication.authenticate(
                            localizedReason:
                                'Authenticate to enable fingerprint',
                            options: const AuthenticationOptions(
                                stickyAuth: true,
                                useErrorDialogs: true,
                                biometricOnly: true),
                          );

                          if (!authenticated) {
                            setState(() {
                              _secured = false;
                              DbProvider().saveAuthState(false);
                            });
                          }
                        } catch (e) {
                          print('Error during biometric authentication: $e');
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Increase your transaction limit by completing the verification process.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalStepThree(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                  child: Text(
                    'Complete Verification'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
