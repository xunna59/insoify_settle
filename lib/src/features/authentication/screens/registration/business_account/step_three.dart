import 'package:flutter/material.dart';

class BusinessStepThree extends StatefulWidget {
  const BusinessStepThree({Key? key}) : super(key: key);

  @override
  State<BusinessStepThree> createState() => _BusinessStepThreeState();
}

class _BusinessStepThreeState extends State<BusinessStepThree> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String phonecode = '';

  String phoneCodeMsg = '';

  void validatePhoneCode(String phonecode) {
    setState(() {
      phoneCodeMsg = (phonecode.isEmpty)
          ? 'Phone Code is Required'
          : phonecode.length < 5
              ? '5 Digit code is required'
              : '';
    });
  }

  void submitform() {
    validatePhoneCode(phonecode);

    if (phoneCodeMsg.isNotEmpty) {
      return;
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLength: 5,
                decoration: InputDecoration(
                  counterText: '',
                  prefixIcon: SizedBox(
                    width: 48,
                    child: Icon(
                      Icons.phone_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Place your logic to send the verification code here
                      },
                      child: Text(
                        'Send Code',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  labelText: 'Phone Verification Code',
                  hintText: 'xxxxx',
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
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                onChanged: (value) {
                  phonecode = value;
                  validatePhoneCode(phonecode);
                },
              ),
              if (phoneCodeMsg.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      phoneCodeMsg,
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
                    'Submit'.toUpperCase(),
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
