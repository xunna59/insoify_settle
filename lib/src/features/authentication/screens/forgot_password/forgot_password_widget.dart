import 'package:flutter/material.dart';
import '../../../../../settle_iapi.dart';
import '../reset_password/reset_password.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String phone = "";
  String _phoneValidationMessage = '';
  var siapi = new SettleIAPI();

  void _validatePhone(String phone) {
    setState(() {
      _phoneValidationMessage =
          phone.isEmpty ? 'Phone number is required!' : '';
    });
  }

  void _submit() async {
    _validatePhone(phone);

    if (_phoneValidationMessage.isNotEmpty) {
      return;
    }

    print('Resending OTP... Please wait...');

    try {
      Map data = {
        'id': phone,
      };

      await siapi.resendOTP(data, phone: phone, type: 'recover',
          callback: (String message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(' $message'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          elevation: 10,
        ));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPassword(
                phone:
                    phone), // Replace ResetPasswordScreen with the actual class of your reset password screen
          ),
        );
      });
    } on NetworkErrorException {
      // hide Activity indicator
      print('Done');
      // handle error - show UI in appropriate language
      print('Network error occurred. Please check your internet connection.');
    } on InvalidResponseException {
      // hide Activity indicator
      print('Done');

      // handle error - show UI in appropriate language
      print('Server error. Try again later.');
    } on ServerErrorException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
        backgroundColor: Colors.red,
      ));
    } catch (e, s) {
      // hide Activity indicator
      print('e');

      // handle all other errors - show UI in appropriate language
      print('An unknown error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Password Reset',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              prefixIcon: SizedBox(
                width: 48,
                child: Icon(
                  Icons.phone_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              labelText: 'Phone Number',
              hintText: 'Phone number',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              labelStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            keyboardType: TextInputType.phone,
            onChanged: (phoneNumber) {
              phone = phoneNumber;
              _validatePhone(phone);
            },
          ),
          if (_phoneValidationMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _phoneValidationMessage,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
              child: Text(
                'Continue'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Remembered Password?',
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
