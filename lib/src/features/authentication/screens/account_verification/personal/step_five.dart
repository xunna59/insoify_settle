import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class PersonalStepFive extends StatefulWidget {
  const PersonalStepFive({Key? key}) : super(key: key);

  @override
  State<PersonalStepFive> createState() => _PersonalStepFiveState();
}

class _PersonalStepFiveState extends State<PersonalStepFive> {
  String selectedOption = 'select option';
  String _selectedOptionValidationMsg = '';
  String _selectedFileValidationMsg = '';

  void _validateBid(String selectedOption) {
    setState(() {
      _selectedOptionValidationMsg =
          (selectedOption == 'select option') ? 'Select Proof of Address' : '';
    });
  }

  void _submit() {
    _validateBid(selectedOption);
    _validateSelectFile(_filename ?? '');

    if (_selectedOptionValidationMsg.isNotEmpty ||
        _selectedFileValidationMsg.isNotEmpty) {
      return;
    }
  }

  void _validateSelectFile(String filename) {
    setState(() {
      _selectedFileValidationMsg =
          (filename.isEmpty) ? 'Upload a Document' : '';
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
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {}
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Upload Proof of Address',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedOption,
                        hint: const Text('Proof Of Address'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedOption = newValue!;
                            _validateBid(selectedOption);
                          });
                        },
                        items: [
                          'select option',
                          'Bank Statement',
                          'Utility Bill',
                          'Letter from a recognised authority',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        underline: Container()),
                  ),
                ),
                if (_selectedOptionValidationMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _selectedOptionValidationMsg,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
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
                if (_selectedFileValidationMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _selectedFileValidationMsg,
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
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
                    child: Text(
                      'Next'.toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
