import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../blocs/singUp/singUp_bloc.dart';
import '../config/locator.dart';
import '../services/authentication_service.dart';
import 'login_page.dart';

class SingUpForm extends StatelessWidget {
  SingUpForm({Key? key}) : super(key: key);
  final authService = getIt<JwtAuthenticationService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterFormBloc(), 
      child: Builder(
        builder: (context) {
          final regFormBloc = context.read<RegisterFormBloc>();
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Sing Up'),
              backgroundColor: Color.fromARGB(255, 9, 54, 131),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FormBlocListener<RegisterFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSubmissionFailed: (context, state) {
                  LoadingDialog.hide(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse!)));
                },
                child: SingleChildScrollView(
                  // ignore: prefer_const_constructors
                  padding: EdgeInsetsDirectional.all(5.5),
                  physics: const ClampingScrollPhysics(),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 40.0),
                        TextFieldBlocBuilder(
                          textFieldBloc: regFormBloc.email,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [
                            AutofillHints.username,
                          ],
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email,
                                color: Colors.blueAccent),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFieldBlocBuilder(
                          textFieldBloc: regFormBloc.username,
                          keyboardType: TextInputType.name,
                          autofillHints: const [
                            AutofillHints.username,
                          ],
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: const Icon(Icons.person,
                                color: Colors.blueAccent),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFieldBlocBuilder(
                          textFieldBloc: regFormBloc.phone,
                          keyboardType: TextInputType.phone,
                          autofillHints: const [
                            AutofillHints.username,
                          ],
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            prefixIcon: const Icon(Icons.phone,
                                color: Colors.blueAccent),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFieldBlocBuilder(
                          textFieldBloc: regFormBloc.password,
                          suffixButton: SuffixButton.obscureText,
                          autofillHints: const [AutofillHints.password],
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock,
                                color: Colors.blueAccent),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFieldBlocBuilder(
                          textFieldBloc: regFormBloc.varifyPassword,
                          suffixButton: SuffixButton.obscureText,
                          autofillHints: const [AutofillHints.password],
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                            labelText: 'Verify Password',
                            prefixIcon: const Icon(Icons.lock,
                                color: Colors.blueAccent),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 6, 49, 122)),
                          ),
                          onPressed: regFormBloc.submit,
                          child: const Text('Register',
                              style: TextStyle(fontSize: 15)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
