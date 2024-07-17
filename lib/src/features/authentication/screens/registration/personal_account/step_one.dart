import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../../../settle_iapi.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../../../../../constants/activity_overlay.dart';
import 'step_two.dart';

class PersonalStepOne extends StatefulWidget {
  const PersonalStepOne({Key? key}) : super(key: key);

  @override
  State<PersonalStepOne> createState() => _PersonalStepOneState();
}

class _PersonalStepOneState extends State<PersonalStepOne> {
  SettleIAPI settleAPI = SettleIAPI();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _obscureText = false;
  DateTime selectedDate = DateTime(1903, 1, 1);
  TextEditingController dateController = TextEditingController();
  String fullname = '';
  String phone = '';
  String addressOne = '';
  String password = '';
  String _fullNameMsg = '';
  String _selectedCountryValidationMsg = '';
  String _selectedStateValidationMsg = '';
  String _cityValidationMsg = '';
  String _addressOneValidationMsg = '';
  String _dateValidationMessage = '';
  String _phoneValidationMsg = '';
  String _passwordValidationMessage = '';
  int accounttype = 1;
  bool _loading = false;

  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> regions = [];
  List<Map<String, dynamic>> city = [];

  GlobalKey<AutoCompleteTextFieldState<String>> _searchTextFieldKey =
      GlobalKey();

  TextEditingController _searchController = TextEditingController();
  List<String> _cities = [];
  String? selectedCityName;
  String? selectedCountryId;
  String? selectedRegionId;
  String? selectedCityId;

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
            if (countries.isNotEmpty && selectedCountryId == null) {
              // selectedCountryId = countries[0]["id"].toString();
              // fetchRegions(selectedCountryId ?? "");
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
              fetchCities(selectedRegionId ?? "");
            }
          }
        });
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print("Error fetching regions: $e");
    }
  }

  Future<void> fetchCities(String regionId) async {
    try {
      final List<dynamic> responseData =
          await settleAPI.fetchCities({"regionId": regionId ?? ""});

      // Assuming responseData is a List<dynamic>
      final List<Map<String, dynamic>> citiesData =
          List<Map<String, dynamic>>.from(responseData);

      setState(() {
        city = citiesData;

        // Populate _cities with city names
        _cities = city.map((city) => city["name"].toString()).toList();

        if (_cities.isNotEmpty) {
          selectedCityId = city[0]["id"].toString();
          _searchTextFieldKey.currentState?.updateSuggestions(_cities);
        }
      });
    } catch (e) {
      print("Error fetching cities: $e");
    }
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

// validate full name
  void _validatefname(String fullname) {
    setState(() {
      _fullNameMsg = (fullname.isEmpty) ? 'Full Name is Required' : '';
    });
  }

// validate phone number
  void _validatePhone(String phone) {
    setState(() {
      _phoneValidationMsg = (phone.isEmpty) ? 'Phone Number is Required' : '';
    });
  }

  void _validateCountry(String selectedCountry) {
    setState(() {
      _selectedCountryValidationMsg =
          (selectedCountry == 'Select Country') ? 'Country is Required' : '';
    });
  }

  void _validateState(String selectedState) {
    setState(() {
      _selectedStateValidationMsg = (selectedState == 'Select State/Region')
          ? 'State/Region is Required'
          : '';
    });
  }

  void _validateCity(String selectedCity) {
    setState(() {
      _cityValidationMsg = (selectedCity.isEmpty) ? 'City is Required' : '';
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

  toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _submit() async {
    _validatefname(fullname);

    _validatePhone(phone);
    //  _validateCountry(selectedCountry);
    _validateCity(_searchController.text);
    _validateAddressOne(addressOne);
    _validatePassword(password);
    _validatedate(selectedDate);
    if (_fullNameMsg.isNotEmpty ||
        _dateValidationMessage.isNotEmpty ||
        _phoneValidationMsg.isNotEmpty ||
        _selectedCountryValidationMsg.isNotEmpty ||
        _cityValidationMsg.isNotEmpty ||
        _addressOneValidationMsg.isNotEmpty ||
        _passwordValidationMessage.isNotEmpty) {
      return;
    }

    LoadingOverlay.show(context);

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    setState(() {
      _loading = true;
    });
    try {
      Map data = {
        "fullname": fullname,
        "cityId": selectedCityName,
        "dob": formattedDate,
        "phone": phone,
        "countryId": selectedCountryId,
        "regionId": selectedRegionId,
        "address": addressOne,
        //   "idfile": "base64",

        "idtype": "",
        "password": password,
        //     "picture": "base64",
        "email": "",
        "actype": "1",
        "idno": "",

        "accategory": "1",
        "language": "en"
      };

      // print('Request Payload: $data');

      await settleAPI.register(data, () {
        LoadingOverlay.hide();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalStepTwo(phone: phone),
          ),
        );
      });
    } on NetworkErrorException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
        backgroundColor: Colors.red,
      ));
    } on InvalidResponseException {
      //hide Activity indicator
    } on ServerErrorException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      //hide Activity indicator
      print('Done');

      //handle all other errors - show UI in appropriate language
      print('An unknown error occured.');
    } finally {
      // Reset loading to false when the request is complete
      setState(() {
        _loading = false;
      });
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                  child: Text(
                    'Create Personal Account',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
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
                        Icons.person_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    labelText: 'Full Name',
                    hintText: 'Full Name',
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
                    fullname = value;
                    _validatefname(fullname);
                  },
                ),
                if (_fullNameMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _fullNameMsg,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                // date of birth
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
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Country',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
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
                          fetchRegions(selectedCountryId ?? "");
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
                      // items: countries.map<DropdownMenuItem<String>>((country) {
                      //   return DropdownMenuItem<String>(
                      //     value: country["id"]
                      //         .toString(), // Use the "id" as the value
                      //     child: Text(country["name"]
                      //         .toString()), // Display the country name
                      //   );
                      // }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                // state dropdown list
                Visibility(
                  visible: selectedCountryId != null &&
                      selectedCountryId!.isNotEmpty,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Region / State',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedCountryId != null &&
                      selectedCountryId!.isNotEmpty,
                  child: Container(
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
                        hint: const Text('Select Region/City'),
                        underline: Container(),
                        value: selectedRegionId,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRegionId = newValue;
                            print(selectedRegionId);
                            fetchCities(selectedRegionId ?? "");
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
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: selectedCountryId != null &&
                        selectedCountryId!.isNotEmpty,
                    child: const SizedBox(height: 10)),
                Visibility(
                  visible: selectedCountryId != null &&
                      selectedCountryId!.isNotEmpty,
                  child: AutoCompleteTextField<String>(
                    key: _searchTextFieldKey,
                    clearOnSubmit: false,
                    suggestions: _cities,
                    controller: _searchController,
                    itemSubmitted: (item) {
                      setState(() {
                        selectedCityName = item; // Update selectedCityName
                        _searchController.text = item;
                        print(selectedCityName);
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: SizedBox(
                        width: 48,
                        child: Icon(
                          Icons.corporate_fare_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      labelText: 'City',
                      hintText: 'City',
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
                    itemFilter: (item, query) {
                      return item.toLowerCase().startsWith(query.toLowerCase());
                    },
                    itemSorter: (a, b) {
                      return a.compareTo(b);
                    },
                    itemBuilder: (context, item) {
                      return ListTile(
                        title: Text(item),
                      );
                    },
                  ),
                ),

                // TextFormField(
                //   decoration: InputDecoration(
                //     prefixIcon: SizedBox(
                //       width: 48,
                //       child: Icon(
                //         Icons.corporate_fare_outlined,
                //         color: Theme.of(context).colorScheme.secondary,
                //       ),
                //     ),
                //     labelText: 'City',
                //     hintText: 'City',
                //     labelStyle: TextStyle(
                //       fontSize: 16,
                //       color: Theme.of(context).colorScheme.secondary,
                //     ),
                //     hintStyle: TextStyle(
                //       fontSize: 14,
                //       color: Theme.of(context).colorScheme.secondary,
                //     ),
                //     border: const OutlineInputBorder(),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(
                //           color: Theme.of(context).colorScheme.secondary),
                //     ),
                //   ),
                //   onChanged: (value) {
                //     // city = value;
                //     // _validateCity(city);
                //   },
                // ),
                if (_cityValidationMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _cityValidationMsg,
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
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      //  foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
                    child: Text(
                      'Proceed'.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                //    if (_loading) CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
