import 'package:flutter/material.dart';
import 'package:settle/providers/db_provider.dart';
import '../../../../../settle_iapi.dart';
import '../../../authentication/screens/account_verification/personal/step_three.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({Key? key}) : super(key: key);

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _obscureText = false;
  String password = '';
  String confirmpassword = '';

  String _passwordValidationMessage = '';
  String _confirmpasswordValidationMessage = '';

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

  var siapi = SettleIAPI();
  void submitform() async {
    _validatePassword(password);
    _validateConfirmPassword(confirmpassword);

    if (_passwordValidationMessage.isNotEmpty ||
        _confirmpasswordValidationMessage.isNotEmpty) {
      return;
    }

    try {
      Map data = {
        'password': password,
      };

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
              Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Change your account password with the form below',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 30.0),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
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
      ),
    );
  }
}
