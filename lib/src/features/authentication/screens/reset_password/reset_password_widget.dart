import 'package:flutter/material.dart';

import '../../../../../settle_iapi.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key, required this.userPhone})
      : super(key: key);
  final String userPhone;
  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var siapi = SettleIAPI();
  bool _obscureText = false;
  String phone = "";
  String _phoneValidationMessage = '';
  String phonecode = '';
  String password = '';
  String confirmpassword = '';
  String phoneCodeMsg = '';
  String _passwordValidationMessage = '';
  String _confirmpasswordValidationMessage = '';

  @override
  void initState() {
    super.initState();
    phone = widget
        .userPhone; // Assign the phone number to the variable in initState
  }

  void _validatePhone(String phone) {
    setState(() {
      _phoneValidationMessage =
          phone.isEmpty ? 'Phone number is required!' : '';
    });
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

  void _validatePassword(String password) {
    setState(() {
      _passwordValidationMessage = password.isEmpty
          ? 'Password is required!'
          : password.length < 8
              ? 'Password must be at least 8 characters long'
              : '';
    });
  }

  void _validateConfirmPassword(String confirmpassword) {
    setState(() {
      _confirmpasswordValidationMessage =
          (confirmpassword != password) ? "Password doesn't match" : '';
    });
  }

  toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void sendotp() async {
    _validatePhone(phone);
    print('Resending Otp in 5.....');

    try {
      Map data = {
        'id': phone,
      };

      await siapi.resendOTP(data, phone: phone, type: 'resend',
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

  void submitform() async {
    _validatePhone(phone);
    validatePhoneCode(phonecode);
    _validatePassword(password);
    _validateConfirmPassword(confirmpassword);

    if (phoneCodeMsg.isNotEmpty ||
        _phoneValidationMessage.isNotEmpty ||
        _passwordValidationMessage.isNotEmpty ||
        _confirmpasswordValidationMessage.isNotEmpty) {
      return;
    }

    print('Updating credentials... Please wait...');

    try {
      Map data = {
        'id': phone,
        'otp': phonecode,
        'password': password,
      };

      await siapi.changePassword(data, () {
        //! no arguments passed in the callback for the register/ endpoint
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You are signed in'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          elevation: 10,
        ));
        Navigator.pushNamed(context, '/dashboard');
        print('Login was successful.');
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
    } catch (e) {
      // Handle other exceptions
      print('An unknown error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('phone number ${widget.userPhone}'),
            // TextField(
            //   decoration: InputDecoration(
            //     prefixIcon: SizedBox(
            //       width: 48,
            //       child: Icon(
            //         Icons.phone_outlined,
            //         color: Theme.of(context).colorScheme.secondary,
            //       ),
            //     ),
            //     labelText: 'Phone Number',
            //     hintText: 'Phone number',
            //     hintStyle: TextStyle(
            //       fontSize: 14,
            //       color: Theme.of(context).colorScheme.tertiary,
            //     ),
            //     border: const OutlineInputBorder(),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide(
            //         color: Theme.of(context).colorScheme.secondary,
            //       ),
            //     ),
            //     labelStyle: TextStyle(
            //       fontSize: 16,
            //       color: Theme.of(context).colorScheme.secondary,
            //     ),
            //   ),
            //   keyboardType: TextInputType.phone,
            //   onChanged: (phoneNumber) {
            //     phone = phoneNumber;
            //     _validatePhone(phone);
            //   },
            // ),
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
            SizedBox(
              height: 10,
            ),
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
              height: 10,
            ),
            TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                prefixIcon: SizedBox(
                  width: 48,
                  child: Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                labelText: 'New Password',
                hintText: 'New Password',
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
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: toggleVisibility,
                ),
              ),
              onChanged: (value) {
                password = value;
                _validatePassword(password);
              },
            ),
            if (_passwordValidationMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _passwordValidationMessage,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: SizedBox(
                  width: 48,
                  child: Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                labelText: 'Verify password',
                hintText: 'Verify password',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                labelStyle: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              onChanged: (value) {
                confirmpassword = value;
                _validateConfirmPassword(confirmpassword);
              },
            ),
            if (_confirmpasswordValidationMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _confirmpasswordValidationMessage,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitform,
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
          ],
        ),
      ),
    );
  }
}
