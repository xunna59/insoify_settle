import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../../settle_iapi.dart';
import 'step_two.dart';

class BusinessStepOne extends StatefulWidget {
  const BusinessStepOne({Key? key}) : super(key: key);

  @override
  State<BusinessStepOne> createState() => _BusinessStepOneState();
}

class _BusinessStepOneState extends State<BusinessStepOne> {
  SettleIAPI settleAPI = SettleIAPI();
  final GlobalKey<FormState> _formKey = GlobalKey();

  String businessname = '';
  // String businessowner = '';
  String selectedBid = 'select option';
  String _businessNameValidationMsg = '';
  String _selectedBidValidationMsg = '';
  String _pickedFileValidatioMsg = '';
  int accounttype = 2;
  List<Map<String, dynamic>> accountCategory = [];
  String? selectedAccountCategory;

  @override
  void initState() {
    super.initState();
    fetchAccountCategories();
  }

  Future<void> fetchAccountCategories() async {
    try {
      await settleAPI.fetchAccategories((data) {
        setState(() {
          if (data is List) {
            accountCategory = List<Map<String, dynamic>>.from(data);
            accountCategory.sort(
                (a, b) => a["name"].toString().compareTo(b["name"].toString()));
            if (accountCategory.isNotEmpty) {
              selectedAccountCategory = accountCategory[0]["id"].toString();
            }
          }
        });
      });
    } catch (e) {
      // Handle any errors or exceptions here
      print("Error fetching countries: $e");
    }
  }

  void _validateBusinessName(String businessname) {
    setState(() {
      _businessNameValidationMsg =
          (businessname.isEmpty) ? 'Business Name is Required' : '';
    });
  }

  void _validateBid(String selectedBid) {
    setState(() {
      _selectedBidValidationMsg = (selectedBid == 'select option')
          ? 'Select Business Identification Method'
          : '';
    });
  }

  void _validatePickedFile() {
    setState(() {
      _pickedFileValidatioMsg = pickedfile == null ? 'File is required' : '';
    });
  }

  FilePickerResult? result;
  String? _filename;
  PlatformFile? pickedfile;
  bool isLoading = false;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        _filename = result!.files.first.name;
        pickedfile = result!.files.first;

        //  print('$_filename');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //  print(e);
    }
  }

  Future<String> _convertFileToBase64() async {
    if (pickedfile == null) {
      return ''; // Handle the case where no file is picked
    }

    try {
      // Extracting path from pickedfile, handling possible null
      String? filePath = pickedfile!.path;

      // Check if filePath is not null before proceeding
      if (filePath != null) {
        // Convert filePath to File
        File file = File(filePath);

        // Read file bytes asynchronously
        List<int> fileBytes = await file.readAsBytes();

        // Convert bytes to base64
        String base64String = await base64Encode(fileBytes);

        return base64String;
      } else {
        print('File path is null.');
        return '';
      }
    } catch (e) {
      print('Failed to get file bytes: $e');
      return '';
    }
  }

  void _submit() async {
    _validateBusinessName(businessname);
    _validateBid(selectedBid);

    _validatePickedFile();

    if (_businessNameValidationMsg.isNotEmpty ||
        _selectedBidValidationMsg.isNotEmpty ||
        _pickedFileValidatioMsg.isNotEmpty) {
      return;
    }

    String base64String = await _convertFileToBase64();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessStepTwo(
            businessname: businessname,
            accountcategory: '$selectedAccountCategory',
            uploadfile: base64String),
      ),
    );

    //String base64String = await _convertFileToBase64();
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
                    'Create Business Account',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Business Information',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      width: 48,
                      child: Icon(
                        Icons.corporate_fare_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    labelText: 'Business Name',
                    hintText: 'Business Name',
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
                    businessname = value;
                    _validateBusinessName(businessname);
                  },
                ),
                if (_businessNameValidationMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _businessNameValidationMsg,
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
                    'Account Category',
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
                      value: selectedAccountCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAccountCategory = newValue;
                          print(selectedAccountCategory);
                        });
                      },
                      items: accountCategory
                          .map<DropdownMenuItem<String>>((category) {
                        return DropdownMenuItem<String>(
                          value: category["id"]
                              .toString(), // Use the "id" as the value
                          child: Text(category["name"]
                              .toString()), // Display the country name
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 20),
                Align(
                  child: Text(
                    'Upload Business Identification Document',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedBid,
                      hint: const Text('Business Identification'),
                      onChanged: (newValue) {
                        setState(() {
                          selectedBid = newValue!;
                          _validateBid(selectedBid);
                        });
                      },
                      items: [
                        'select option',
                        'Certificate of Incorporation / Registration',
                        'Business license / permit',
                        'Financial statement',
                        'Bank reference letter',
                        'Proof of business activities e.g. invoices or contracts',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      underline: Container(),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_selectedBidValidationMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _selectedBidValidationMsg,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            pickFile();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          child: Text(
                            'Select File',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                const SizedBox(height: 10),
                if (pickedfile != null) Text('Selected file: $_filename'),
                if (_pickedFileValidatioMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _pickedFileValidatioMsg,
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
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
