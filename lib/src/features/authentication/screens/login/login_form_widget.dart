import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../providers/db_provider.dart';
import '../../../../../providers/locale_provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../settle_iapi.dart';
import '../../../../constants/activity_overlay.dart';
import '../../../core/screens/dashboard/dashboard.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final LocalAuthentication auth;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _supportState = false;
  bool _obscureText = true;
  String _phoneValidationMessage = '';
  String _passwordValidationMessage = '';
  bool _isBiometricsAllowed = false;
  bool _loading = false;
  var siapi = SettleIAPI();

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );

    DbProvider().getAuthState().then((value) {
      if (value == false) {
        _isBiometricsAllowed = false;
      } else {
        _isBiometricsAllowed = true;
      }
    });
  }

  Future<void> _storeCredentials(String phone, String password) async {
    await Future.wait([
      _secureStorage.write(key: 'phone', value: phone),
      _secureStorage.write(key: 'password', value: password),
    ]);
  }

  Future<void> _readCredentialsAndLogin() async {
    String? phone = await _secureStorage.read(key: 'phone');
    String? password = await _secureStorage.read(key: 'password');

    if (phone != null && password != null) {
      setState(() {
        phoneController.text = phone;
        passwordController.text = password;
      });

      _loginWithCredentials(phone, password);
    } else {
      print('Credentials not found');
    }
  }

  Future<void> _loginWithCredentials(String phone, String password) async {
    Map data = {'id': phone, 'password': password};

    try {
      await siapi.login(data, () async {
        await _storeCredentials(phone, password);
        await _setLoggedInStatus(true, phone);

        showSnackBar('You are signed in', Colors.green);
        navigateToDashboard();
      });
    } catch (e) {
      handleError(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _setLoggedInStatus(bool isLoggedIn, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    setState(() {
      phoneController.text = phone;
    });
  }

  void toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _validatePhone(String phone) {
    setState(() {
      _phoneValidationMessage =
          phone.isEmpty ? 'Phone number is required!' : '';
    });
  }

  void _validatePassword(String password) {
    setState(() {
      _passwordValidationMessage =
          password.isEmpty ? 'Password is required!' : '';
    });
  }

  void _submit() async {
    _validatePhone(phoneController.text);
    _validatePassword(passwordController.text);

    if (_phoneValidationMessage.isNotEmpty ||
        _passwordValidationMessage.isNotEmpty) {
      return;
    }

    final phone = phoneController.text;
    final password = passwordController.text;

    LoadingOverlay.show(context);

    try {
      await _loginWithCredentials(phone, password);
    } finally {
      LoadingOverlay.hide();
    }

    // _loginWithCredentials(phone, password);
  }

  void handleError(dynamic error) {
    if (error is NetworkErrorException) {
      showSnackBar(
          'Network error occurred. Please check your internet connection.',
          Colors.red);
    } else if (error is ServerErrorException) {
      showSnackBar('Invalid login credentials', Colors.red);
    } else {
      // Handle other exceptions
      showSnackBar('An error occurred, try again later', Colors.red);
    }
  }

  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ),
    );
  }

  void navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeState = ref.watch(localeProvider);
    var selectedLocale = localeState.locale;

    final localeNotifier = ref.read(localeProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          TextField(
            controller: phoneController,
            decoration: InputDecoration(
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
          ),
          if (_phoneValidationMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                _phoneValidationMessage,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Password',
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
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.secondary),
              ),
              suffixIcon: IconButton(
                onPressed: toggleVisibility,
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          if (_passwordValidationMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _passwordValidationMessage,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
          // Center(
          //   child: _loading
          //       ? CircularProgressIndicator(
          //           backgroundColor: Colors.blue,
          //           color: Colors.red,
          //         )
          //       : Container(),
          // ),
          // const SizedBox(height: 20),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed:
          //         _loading ? null : _submit, // Disable button when loading
          //     style: ElevatedButton.styleFrom(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //     ),
          //     child: Text(
          //       'Login'.toUpperCase(),
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Theme.of(context).colorScheme.primary,
          //       ),
          //     ),
          //   ),
          // ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  _loading ? null : _submit, // Disable button when loading
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
              icon: Icon(
                Icons.login,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                'Login'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          if (_loading) CircularProgressIndicator(),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: _isBiometricsAllowed,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                icon: const Icon(Icons.fingerprint_outlined),
                iconSize: 34,
                onPressed: _authenticate,
              ),
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),

          // Center(
          //   child: DropdownButton<Locale>(
          //     value:
          //         selectedLocale, // Use the Locale object as the default value
          //     onChanged: (newLocale) {
          //       if (newLocale != null) {
          //         setState(() {
          //           selectedLocale = newLocale;
          //         });
          //         localeNotifier.setLocale(newLocale);
          //         // Save the selected locale to SharedPreferences or any other storage mechanism
          //         // LocaleManager.setLocale(newLocale.languageCode);
          //       }
          //     },
          //     items: AppLocalizations.supportedLocales
          //         .map<DropdownMenuItem<Locale>>(
          //           (locale) => DropdownMenuItem(
          //             value: locale, // Use the Locale object
          //             child: Text(locale.languageCode),
          //           ),
          //         )
          //         .toList(),
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextButton(
                onPressed: null,
                child: Text(
                  "Don't have an account yet?",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  'Sign Up',
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

  Future<void> _authenticate() async {
    _getAvailableBiometrics;
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Sign In',
        options:
            const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );

      if (authenticated) {
        await _readCredentialsAndLogin();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
  }
}
