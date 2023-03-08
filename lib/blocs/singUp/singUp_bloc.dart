import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../services/authentication_service.dart';

class RegisterFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final phone = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      (value) {
        if (value.isEmpty) {
          return 'Please, put a number phone';
        } else if (value.length != 9 || !RegExp(r'^\d{9}$').hasMatch(value)) {
          return 'The number phone must have 9 digits!';
        }
      },
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final varifyPassword = TextFieldBloc(validators: [
    FieldBlocValidators.required,
  ]);

  final showSuccessResponse = BooleanFieldBloc();

  RegisterFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
        username,
        phone,
        password,
        varifyPassword,
        showSuccessResponse,
      ],
    );
  }

  @override
  void onSubmitting() async {
    debugPrint(email.value);
    debugPrint(username.value);
    debugPrint(phone.value);
    debugPrint(password.value);
    debugPrint(varifyPassword
        .value); /*
    debugPrint(showSuccessResponse.value.toString());*/

    JwtAuthenticationService().singUp(username.value, email.value, phone.value,
        password.value, varifyPassword.value);
    await Future<void>.delayed(const Duration(seconds: 5));

    final response = await JwtAuthenticationService().singUp(username.value,
        email.value, phone.value, password.value, varifyPassword.value);

    if (response.statusCode == 400) {
      final errorJson = json.decode(response.body);
      final subErrors = errorJson['subErrors'] ?? [];
      final errorMessages = subErrors.map((e) => e['message']).toList();
      final errorMessage = 'Validation error: ${errorMessages.join(', ')}';
      emitFailure(failureResponse: errorMessage);
    } else {
      emitSuccess();
    }
  }
}
