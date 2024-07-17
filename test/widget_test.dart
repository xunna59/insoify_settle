// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:settle/main.dart';
import 'package:settle/settle_iapi.dart';

void main() {
  var siapi = new SettleIAPI();

  //get countries
  print('Settle countries ********************************************');
  try {
    siapi.fetchCountries((countries) {
      countries.forEach((element) {
        print('id: ' + element['id'] + 'name: ' + element['name']);
      });
    });
  } on NetworkErrorException {
    //handle error - show UI in appropriate language

    print('Network error occured.');
  } on InvalidResponseException {
    //handle error - show UI in appropriate language

    print('Server error. Try again later.');
  } on ServerErrorException {
    //handle error - show UI in appropriate language

    print('Server error. Try again later.');
  } catch (e) {
    //handle all other errors - show UI in appropriate language
    print(e);
    print('An unknown error occured.');
  }
}
