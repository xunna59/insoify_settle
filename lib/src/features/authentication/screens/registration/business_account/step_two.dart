import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../settle_iapi.dart';

import 'step_three.dart';

class BusinessStepTwo extends StatefulWidget {
  const BusinessStepTwo({
    Key? key,
    required this.businessname,
    required this.accountcategory,
    required this.uploadfile,
  }) : super(key: key);
  final String businessname;
  final String accountcategory;
  final String uploadfile;
  @override
  State<BusinessStepTwo> createState() => _BusinessStepTwoState();
}

class _BusinessStepTwoState extends State<BusinessStepTwo> {
  SettleIAPI settleAPI = SettleIAPI();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _obscureText = false;
  DateTime selectedDate = DateTime(1903, 1, 1);
  TextEditingController dateController = TextEditingController();
  String _dateValidationMessage = '';
  String businessowner = '';
  String phone = '';
  String selectedCountry = 'Select Country';
  String selectedState = "Select State/Region";
  String addressOne = '';
  String password = '';
  String _businessOwnerValidationMsg = '';
  String _phoneValidationMsg = '';
  String _addressOneValidationMsg = '';
  String _passwordValidationMessage = '';
  String _selectedCountryValidationMsg = '';
  String _selectedStateValidationMsg = '';

  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> regions = [];
  // List<Map<String, dynamic>> city = [];
  String? selectedCountryId;
  String? selectedRegionId;
  // String? selectedCityId;

  @override
  void initState() {
    super.initState();
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
            if (countries.isNotEmpty) {
              selectedCountryId = countries[0]["id"].toString();
              fetchRegions(selectedCountryId ?? "");
            }
          }
        });
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print("Error fetching countries: $e");
    }
  }

  Future<void> fetchRegions(String countryId) async {
    try {
      await settleAPI.fetchRegions({"countryId": countryId ?? ""}, (data) {
        setState(() {
          if (data is List) {
            regions = List<Map<String, dynamic>>.from(data);
            regions.sort(
                (a, b) => a["name"].toString().compareTo(b["name"].toString()));
            if (regions.isNotEmpty) {
              selectedRegionId = regions[0]["id"].toString();
              //   fetchCities(selectedRegionId ?? "");
            }
          }
        });
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print("Error fetching regions: $e");
    }
  }

  void _validateBusinessOwner(String businessowner) {
    setState(() {
      _businessOwnerValidationMsg =
          (businessowner.isEmpty) ? "Business Owner's Name is Required" : '';
    });
  }

  void _validateCountry(String selectedCountry) {
    setState(() {
      _selectedCountryValidationMsg =
          (selectedCountry.isEmpty) ? 'Country is Required' : '';
    });
  }

  void _validateState(String selectedState) {
    setState(() {
      _selectedStateValidationMsg =
          (selectedState.isEmpty) ? 'State/Region is Required' : '';
    });
  }

  void _validatePhone(String phone) {
    setState(() {
      _phoneValidationMsg = (phone.isEmpty) ? 'Phone Number is Required' : '';
    });
  }

  void _validateAddressOne(String addressOne) {
    setState(() {
      _addressOneValidationMsg =
          (addressOne.isEmpty) ? 'Address is Required' : '';
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

  toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // validate Date of birth selection
  void _validatedate(DateTime selectedDate) {
    final currentDate = DateTime.now();
    final minAgeDate = currentDate.subtract(const Duration(days: 365 * 18));
    final maxAgeDate = currentDate.subtract(const Duration(days: 365 * 120));

    setState(() {
      if (selectedDate.isAfter(minAgeDate)) {
        _dateValidationMessage = 'Minimum acceptable age is 18';
      } else if (selectedDate.isBefore(maxAgeDate)) {
        _dateValidationMessage = 'Maximum age exceeded';
      } else {
        _dateValidationMessage = '';
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 120)),
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

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${picked.toLocal()}".split(' ')[0];
        _validatedate(selectedDate);
      });
    } else if (picked == null) {
      setState(() {
        selectedDate = DateTime.now();
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
        _validatedate(selectedDate);
      });
    }
  }

  void submitform() async {
    _validatedate(selectedDate);
    _validateBusinessOwner(businessowner);
    _validatePhone(phone);
    _validateCountry(selectedCountry);
    _validateState(selectedState);
    _validateAddressOne(addressOne);
    _validatePassword(password);

    if (_dateValidationMessage.isNotEmpty ||
        _phoneValidationMsg.isNotEmpty ||
        _selectedCountryValidationMsg.isNotEmpty ||
        _selectedStateValidationMsg.isNotEmpty ||
        _addressOneValidationMsg.isNotEmpty ||
        _passwordValidationMessage.isNotEmpty ||
        _businessOwnerValidationMsg.isNotEmpty) {
      return;
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const BusinessStepThree(),
    //   ),
    // );
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    print('Creating Business account... Please wait...');

    try {
      Map data = {
        // business account data
        "fullname": businessowner,
        "bizname": widget.businessname,
        "dob": formattedDate,
        "email": "",
        "phone": phone,
        "countryId": selectedCountryId,
        "regionId": selectedRegionId,
        "address": addressOne,
        "password": password,
        "idtype": "",
        "accategory": widget.accountcategory,
        "actype": "2",
        "language": "en",
        "idno": "",
        "idfile": widget.uploadfile,
      };

      print('Request Payload: $data');

      await settleAPI.register(data, () {
        Navigator.pushNamed(context, '/business-step-two');
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Business Owner Information',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      width: 48,
                      child: Icon(
                        Icons.person_2_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    labelText: 'Business Owner (Fullname)',
                    hintText: 'Business Owner (Fullname)',
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
                    businessowner = value;
                    _validateBusinessOwner(businessowner);
                  },
                ),
                if (_businessOwnerValidationMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _businessOwnerValidationMsg,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    labelText: 'Date of birth',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                if (_dateValidationMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _dateValidationMessage,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
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
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      isExpanded: true,
                      underline: Container(),
                      value: selectedCountryId,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCountryId = newValue;
                          fetchRegions(selectedCountryId ?? "");
                        });
                      },
                      items: countries.map<DropdownMenuItem<String>>((country) {
                        return DropdownMenuItem<String>(
                          value: country["id"]
                              .toString(), // Use the "id" as the value
                          child: Text(country["name"]
                              .toString()), // Display the country name
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (_selectedCountryValidationMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _selectedCountryValidationMsg,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
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
                      isExpanded: true,
                      underline: Container(),
                      value: selectedRegionId,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRegionId = newValue;
                          print(selectedRegionId);
                          //  fetchCities(selectedCityId ?? "");
                        });
                      },
                      items: regions.map<DropdownMenuItem<String>>((region) {
                        return DropdownMenuItem<String>(
                          value: region["id"]
                              .toString(), // Use the "id" as the value
                          child: Text(region["name"]
                              .toString()), // Display the region name
                        );
                      }).toList(),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                    ),
                  ),
                ),
                if (_selectedStateValidationMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _selectedStateValidationMsg,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      width: 48,
                      child: Icon(
                        Icons.house_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    labelText: 'Address',
                    hintText: 'Address',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  onChanged: (value) {
                    addressOne = value;
                    _validateAddressOne(addressOne);
                  },
                ),
                if (_addressOneValidationMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _addressOneValidationMsg,
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
      ),
    );
  }
}
