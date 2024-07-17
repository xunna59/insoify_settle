import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/locale_provider.dart';
import 'src/features/authentication/screens/forgot_password/forgot_password.dart';
import 'src/features/authentication/screens/login/login_screen.dart';
import 'src/features/authentication/screens/registration/business_account/step_one.dart';
import 'src/features/authentication/screens/registration/personal_account/step_one.dart';
import 'src/features/authentication/screens/registration/register_screen.dart';
import 'src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'src/features/core/screens/dashboard/dashboard.dart';
import 'src/utils/theme/theme.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(localeProvider);

    return MaterialApp(
      theme: XAppTheme.lightTheme,
      darkTheme: XAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreenSaver(),
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      // locale: localeState.locale,
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/personal-step-one': (context) => const PersonalStepOne(),
        '/business-step-one': (context) => const BusinessStepOne(),
        //   '/business-step-two': (context) =>  BusinessStepTwo(),
      },
    );
  }
}
