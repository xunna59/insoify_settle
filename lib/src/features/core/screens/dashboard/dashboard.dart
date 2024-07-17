import 'package:flutter/material.dart';
import '../../../../../settle_iapi.dart';
import '../../../authentication/screens/account_verification/personal/step_three.dart';
import '../account/account.dart';
import '../funds_transfer/send_money.dart';
import 'transaction_tabs.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool hasNewNotification = true;

  bool hideAmount = false;

  DateTime fromDate = DateTime.now();

  DateTime toDate = DateTime.now();

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Theme.of(context).colorScheme.primary,
              onSurface: Theme.of(context).colorScheme.secondary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Theme.of(context).colorScheme.primary,
              onSurface: Theme.of(context).colorScheme.secondary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
    }
  }

  void toggleAmountVisibility() {
    setState(() {
      hideAmount = !hideAmount; // Toggle visibility
    });
  }

  late String fullName = '';
  late String totalWeek = '';
  String firstName = '';
  String currencySymbol = '';
  int thisWeekAmount = 0;
  void initState() {
    super.initState();
    userDashboard();
  }

  Future<void> userDashboard() async {
    print("\nLoading dashboard...");
    try {
      // load up dashboard straightaway - show Activity indicator
      print("\nLoading dashboard...");

      var siapi = SettleIAPI(); // Create a new instance

      if (!siapi.isAuthorized) {
        throw UnauthorizedRequestException();
        // Check authorization
      }

      Map dashboard = await siapi.fetchProfile();

      setState(() {
        fullName = dashboard['fullname'] ?? 'John Doe';
        totalWeek = dashboard['thisweek'];

        // Extract currency symbol and numeric value
        // Extract currency symbol and numeric value
        var regex = RegExp(r"([A-Za-z]+)(\d+)");
        var match = regex.firstMatch(totalWeek);

        if (match != null) {
          currencySymbol = match.group(1) ?? '';
          String thisWeekValue = match.group(2) ?? '';
          thisWeekAmount = int.tryParse(thisWeekValue) ?? 0;

          print('currencySymbol: $currencySymbol');
          print('thisWeekAmount: $thisWeekAmount');
        } else {
          // Handle the case when the regex does not match
        }

        List<String> fName = fullName.split(' ');
        firstName = fName.first;
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

      // Handle unauthorized request, e.g., navigate to the login screen
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat('#,###');
    String formattedAmount = formatter.format(thisWeekAmount);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(40.0),
              ),
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                height: 260,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'Hello, $firstName',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PersonalStepThree(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.warning,
                              color: Colors.yellow,
                              size: 16,
                            ),
                            label: const Text(
                              'Verify Account',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Stack(
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountScreen(),
                                      ),
                                    );
                                  },
                                  icon: Stack(
                                    children: [
                                      const Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                        size: 28.0,
                                      ),
                                      if (hasNewNotification)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: const Text(
                                              '•',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'This Week',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Text(
                              hideAmount
                                  ? '******'
                                  : '$currencySymbol $formattedAmount',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  toggleAmountVisibility, // Toggle visibility on click
                              icon: const Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                        width: double.infinity,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // navigate to send money page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SendMoney(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.black87,
                              ),
                              label: const Text(
                                'Send Money',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    InkWell(
                        onTap: () => _selectFromDate(context),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            fromDate != null
                                ? "From: ${DateFormat('yyyy-MM-dd').format(fromDate)}"
                                : 'Select From Date',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    // const Text(
                    //   '-',
                    //   style:
                    //       TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    // ),
                    const Icon(Icons.trending_flat_outlined),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () => _selectToDate(context),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          toDate != null
                              ? "To: ${DateFormat('yyyy-MM-dd').format(toDate)}"
                              : 'Select To Date',
                          style: TextStyle(
                            fontSize: 12,
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
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TransactionTabs(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
