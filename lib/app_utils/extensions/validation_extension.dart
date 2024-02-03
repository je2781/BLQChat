import 'package:flutter/material.dart';

extension ValidationExtension on BuildContext {
  String? validateFieldNotEmpty(String? value) => value == null || value.isEmpty
      ? 'Field cannot be empty'
      : value.length < 3
          ? 'Field must have more than 2 characters'
          : null;

  String? validateFieldNotNull<T>(T? value) =>
      value == null ? 'Field cannot be empty' : null;

  String? validateFullName<T>(String? value) {
    if (value == null) return 'Full name field cannot be empty';

    if (value.isEmpty) return 'Full name field cannot be empty';

    if (value.split(' ').length < 2) return 'Please enter your full name';

    return null;
  }

  String? validateEmailAddress(String? value) {
    if (value == null) return 'Email field cannot be empty';
    if (value.isEmpty) return 'Email field cannot be empty';

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`~{|}]+@[a-zA-Z0-9]+\.[a-zA-Z]")
        .hasMatch(value);

    return !emailValid ? 'Enter a valid email address' : null;
  }

  String? validatePassword(String? value) => value == null || value.length <= 3
      ? 'Password must have 4 or more characters'
      : null;
}
