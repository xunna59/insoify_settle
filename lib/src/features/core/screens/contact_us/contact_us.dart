import 'package:flutter/material.dart';

import '../../../../../settle_iapi.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String message = '';
  String _messageMsg = '';
  bool _loading = false;

  void _validatemessage(String message) {
    setState(() {
      _messageMsg = (message.isEmpty) ? 'Message is Required' : '';
    });
  }

  void _submit() async {
    _validatemessage(message);

    if (_messageMsg.isNotEmpty) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      var siapi = SettleIAPI();

      Map data = {
        'id': siapi.id,
        'complain': message,
      };

      await siapi.report(data, () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Dispute filed successfully.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          elevation: 10,
        ));
        setState(() {
          message = '';
        });
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Send in your comments, questions and messages',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Type message...',
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
                      maxLines: 6,
                      onChanged: (text) {
                        message = text;
                        _validatemessage(message);
                      },
                    ),
                    if (_messageMsg.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _messageMsg,
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
                          //  foregroundColor: Colors.white,
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
                ))
          ],
        ),
      ),
    );
  }
}
