import 'package:flutter/material.dart';

import '../../../../../../settle_iapi.dart';

class PersonalStepTwo extends StatefulWidget {
  const PersonalStepTwo({Key? key, required this.phone}) : super(key: key);

  final String phone;

  @override
  State<PersonalStepTwo> createState() => _PersonalStepTwoState();
}

class _PersonalStepTwoState extends State<PersonalStepTwo> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var siapi = SettleIAPI();
  String uphone = "";
  String phonecode = '';

  String phoneCodeMsg = '';

  @override
  void initState() {
    super.initState();
    uphone =
        widget.phone; // Assign the phone number to the variable in initState
  }

  void validatePhoneCode(String phonecode) {
    setState(() {
      phoneCodeMsg = (phonecode.isEmpty)
          ? 'Phone Code is Required'
          : phonecode.length < 5
              ? '5 Digit code is required'
              : '';
    });
  }

  void submitform() {
    validatePhoneCode(phonecode);

    if (phoneCodeMsg.isNotEmpty) {
      return;
    }
  }

  void sendotp() async {
    print('Resending Otp in 5.....');

    try {
      Map data = {
        'id': uphone,
      };

      await siapi.resendOTP(data, phone: uphone, type: 'resend',
          callback: (String message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(' $message'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          elevation: 10,
        ));
      });
    } on NetworkErrorException {
      print('Network error occurred. Please check your internet connection.');
    } on ServerErrorException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
          child: Text(
            'Invalid login credentials',
          ),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    } catch (e, s) {
      // Print the exception and stack trace
      print('An unknown error occurred. Exception: $e, Stack trace: $s');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                maxLength: 5,
                decoration: InputDecoration(
                  counterText: '',
                  prefixIcon: SizedBox(
                    width: 48,
                    child: Icon(
                      Icons.password_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: sendotp,
                      child: Text(
                        'Send Code',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  labelText: 'Phone Verification Code',
                  hintText: 'xxxxx',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                onChanged: (value) {
                  phonecode = value;
                  validatePhoneCode(phonecode);
                },
              ),
              if (phoneCodeMsg.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      phoneCodeMsg,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitform,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                  child: Text(
                    'Next'.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
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
