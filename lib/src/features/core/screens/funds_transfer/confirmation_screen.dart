import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../settle_iapi.dart';
import '../../../../constants/activity_overlay.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({
    Key? key,
    required this.phone,
    required this.accountnumber,
    required this.currency,
    required this.amount,
    required this.country,
  }) : super(key: key);

  final phone;
  final accountnumber;
  final currency;
  final amount;
  final country;

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  late String userCountry = '';
  var siapi = SettleIAPI();
  List<Map<String, dynamic>> countries = [];
  String? selectedCountryId;
  bool isLoading = false;
  String? theCountryId;
  late String rate;
  void initState() {
    super.initState();
    // userDashboard();
    // fetchCountries();

    fetchDataAndCompare();
  }

  Future<void> fetchDataAndCompare() async {
    try {
      //   LoadingOverlay.show(context);
      await fetchCountries();
      await userDashboard();
      retrieveCountryId();
      await getRate();
    } catch (e) {
      // Handle any errors or exceptions here
      print("Error: $e");
      LoadingOverlay.hide();
    } finally {
      //  LoadingOverlay.hide();
    }
  }

  Future<void> fetchCountries() async {
    try {
      await siapi.fetchCountries((data) {
        setState(() {
          if (data is List) {
            countries = List<Map<String, dynamic>>.from(data);
            countries.sort(
                (a, b) => a["name"].toString().compareTo(b["name"].toString()));
            if (countries.isNotEmpty) {
              selectedCountryId = countries[0]["id"].toString();
            }
          }
        });
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print("Error fetching countries: $e");
    }
  }

  Future<void> userDashboard() async {
    print("\nLoading dashboard...");
    try {
      // load up dashboard straightaway - show Activity indicator
      print("\nLoading dashboard...");

      String dataCountry = widget.country;
      if (!siapi.isAuthorized) {
        throw UnauthorizedRequestException();
        // Check authorization
      }

      Map dashboard = await siapi.fetchProfile();

      setState(() {
        userCountry = dashboard['country'] ?? '';
      });

      // hide Activity indicator
      print('\nDone');
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

  void retrieveCountryId() {
    // Trim leading and trailing whitespaces from userCountry
    String trimmedUserCountry = userCountry.trim().toLowerCase();

    // Check if the countries list is empty
    if (countries.isEmpty) {
      print('The list of countries is empty.');
      return;
    }

    countries.forEach((country) {
      String trimmedCountryName =
          country['name'].toString().trim().toLowerCase();
    });

    // Assuming 'countries' is the list of countries
    Map<String, dynamic>? countryEntry;

    for (var country in countries) {
      // Trim leading and trailing whitespaces from the country name
      String trimmedCountryName =
          country['name'].toString().trim().toLowerCase();

      // Check if the user's country matches the country in the list
      if (trimmedCountryName.contains(trimmedUserCountry)) {
        countryEntry = country;
        break;
      }
    }

    if (countryEntry != null) {
      theCountryId = countryEntry['id'].toString();
      print('ID of The Country is: $theCountryId');
    } else {
      print('Country not found in the list of countries.');
    }
  }

  Future<void> getRate() async {
    print('Fetching Rates.....');

    try {
      Map data = {
        'source': theCountryId,
        'destination': widget.country,
        'amount': widget.amount,
      };

      print('Data: $data');
      LoadingOverlay.show(context);

      dynamic result = await siapi.fetchRates(data);

      print(result);

      rate = result['rate'];

      print('This is the rate: $rate');

      String accountName = result is Map ? result['name'].toString() : '';

      setState(() {
        LoadingOverlay.hide();
      });
    } on UnauthorizedRequestException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
      ));
    } on NetworkErrorException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
      ));
    } on ServerErrorException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'Transfer Confirmation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Please review the details below before confirming the transfer.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            _buildConfirmationInfo('Phone Number', widget.phone),
            _buildConfirmationInfo('Account Number', widget.accountnumber),
            _buildConfirmationInfo('Amount', '\$$widget.amount'),
            SizedBox(
              height: 30,
            ),
            Text(
              'Transaction Rate: ',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                'Confirm Transfer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
