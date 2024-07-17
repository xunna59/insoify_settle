import 'package:flutter/material.dart';
import '../../../../constants/activity_overlay.dart';
import '../../../../constants/currency.dart';
import '../../../../../../settle_iapi.dart';
import 'confirmation_screen.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key}) : super(key: key);

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  SettleIAPI settleAPI = SettleIAPI();
  String selectedCurrency = 'Select Currency';
  bool showAccountName = false;

  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> methods = [];
  String? selectedCountryId;
  String? selectedMethod;
  TextEditingController accountNameController = TextEditingController();

  String phone = '';
  String _phoneValidationMsg = '';
  String accountNumber = '';
  String _accountNumValidationMsg = '';
  String amount = '';
  String _amountValidationMsg = '';

  // validate phone number
  void _validatePhone(String phone) {
    setState(() {
      _phoneValidationMsg = (phone.isEmpty) ? 'Phone Number is Required' : '';
    });
  }

  void _validateAccountNumber(String accountNumber) {
    setState(() {
      _accountNumValidationMsg =
          (accountNumber.isEmpty) ? 'Account Number is Required' : '';
    });
  }

  void _validateAmount(String newamount) {
    setState(() {
      _amountValidationMsg = (newamount.isEmpty) ? 'Amount is Required' : '';
    });
  }

  @override
  void initState() {
    super.initState();
    selectedCountryId = null;
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      await settleAPI.fetchCountries((data) {
        setState(() {
          if (data is List) {
            countries = List<Map<String, dynamic>>.from(data);
            countries.sort(
                (a, b) => a["name"].toString().compareTo(b["name"].toString()));
            // Set selectedCountryId to the first country only if it is null
            if (countries.isNotEmpty && selectedCountryId == null) {
              //  selectedCountryId = countries[0]["id"].toString();

              //     fetchMethods(selectedCountryId!);
            }
          }
        });
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print("Error fetching countries: $e");
    }
  }

  Future<void> fetchMethods(String countryId) async {
    try {
      await settleAPI.fetchMethods({"countryId": countryId ?? ""}, (data) {
        setState(() {
          if (data is List) {
            methods = List<Map<String, dynamic>>.from(data);
            methods.sort(
                (a, b) => a["name"].toString().compareTo(b["name"].toString()));
            if (methods.isNotEmpty) {
              selectedMethod = methods[0]["id"]
                  .toString(); // Set the default selected region ID
            }
          }
        });
      });
    } on NetworkErrorException {
      print('Network error occured. Please check your internet connection.');
    } on InvalidResponseException {
      print('Server error. Try again later.');
    } on ServerErrorException catch (e) {
      print('Server error: ${e.message}');
    } catch (e, s) {
      print('An unknown error occured.');
      print(e);
      print(s);
    }
  }

  Future<void> validateAccount() async {
    print('Validating Account Number.....');

    try {
      Map data = {
        'fid': selectedCountryId,
        'accountNumber': selectedMethod,
      };
      LoadingOverlay.show(context);

      dynamic result = await settleAPI.validateFIN(data);

      String accountName = result is Map ? result['name'].toString() : '';

      setState(() {
        LoadingOverlay.hide();
        showAccountName = true;
        accountNameController.text = accountName;
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

  void someAsyncFunction() async {
    _validateAccountNumber(accountNumber);

    if (_accountNumValidationMsg.isNotEmpty) {
      return;
    }
    await validateAccount();
  }

  void initiateTransfer() async {
    print('Initiating transfer...');
    LoadingOverlay.show(context);
    _validatePhone(phone);
    _validateAmount(amount);
    _validateAccountNumber(accountNumber);
    print('validated');
    if (_phoneValidationMsg.isNotEmpty ||
        _accountNumValidationMsg.isNotEmpty ||
        _amountValidationMsg.isNotEmpty) {
      return;
    }
    LoadingOverlay.hide();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          phone: phone,
          accountnumber: accountNumber,
          currency: selectedCurrency,
          amount: amount,
          country: selectedCountryId,
        ),
      ),
    );
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
              const Text(
                'SENDER',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
                thickness: 1.0,
              ),
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: Container(),
                      value: selectedCurrency,
                      hint: const Text('Select Currency'),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCurrency = newValue!;
                        });
                      },
                      items: currencies.map((String method) {
                        return DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                    )),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Amount',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: ' Amount',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (newAmount) {
                  amount = newAmount;
                  _validateAmount(amount);
                },
              ),
              if (_amountValidationMsg.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _amountValidationMsg,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 30.0),
              const Text(
                'RECEIVER',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
                thickness: 1.0,
              ),
              const SizedBox(height: 20.0),
              Text(
                'Phone number',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (phoneNumber) {
                  phone = phoneNumber;
                  _validatePhone(phone);
                },
              ),
              if (_phoneValidationMsg.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _phoneValidationMsg,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10.0),
              Text(
                'Country',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    isExpanded: true,
                    underline: Container(),
                    value: selectedCountryId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCountryId = newValue;
                        fetchMethods(selectedCountryId ?? "");
                        print(selectedCountryId);
                      });
                    },
                    items: [
                      // Adding an extra item for "Select Country"
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text('Select Country'),
                      ),
                      // Mapping countries to DropdownMenuItem
                      ...countries.map<DropdownMenuItem<String>>((country) {
                        return DropdownMenuItem<String>(
                          value: country["id"].toString(),
                          child: Text(country["name"].toString()),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Method',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: selectedCountryId != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButton<String>(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              isExpanded: true,
                              underline: Container(),
                              value: selectedMethod,
                              hint: const Text('Select Method'),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedMethod = newValue!;
                                });
                              },
                              items: [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: const Text('Select Method'),
                                ),
                                ...methods
                                    .map<DropdownMenuItem<String>>((method) {
                                  return DropdownMenuItem<String>(
                                    value: method["id"].toString(),
                                    child: Text(method["name"].toString()),
                                  );
                                }).toList(),
                              ],
                            ),
                          ],
                        )
                      : DropdownButton<String>(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          isExpanded: true,
                          underline: Container(),
                          hint: const Text('Select Method'),
                          onChanged: (newValue) {},
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: const Text('Select Method'),
                            ),
                          ],
                        ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  Text(
                    'Account number',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Account number',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (accountNum) {
                      accountNumber = accountNum;
                      _validateAccountNumber(accountNumber);
                    },
                  ),
                  if (_accountNumValidationMsg.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _accountNumValidationMsg,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  if (showAccountName)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Account name',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          readOnly: true, // Make the field uneditable
                          controller: accountNameController,
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: showAccountName
                    ? ElevatedButton(
                        onPressed: () {
                          initiateTransfer();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                        child: Text(
                          'Transfer'.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          someAsyncFunction();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                        child: Text(
                          'Validate Account Number'.toUpperCase(),
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
