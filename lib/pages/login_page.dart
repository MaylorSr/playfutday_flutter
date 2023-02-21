// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:playfutday_flutter/repositories/register_repositories/register_repositoy.dart';
import 'package:playfutday_flutter/repositories/user_repository.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../blocs/authentication/authentication_state.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import '../config/locator.dart';
import '../services/services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            minimum: const EdgeInsets.all(16),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                final authBloc = BlocProvider.of<AuthenticationBloc>(context);
                if (state is AuthenticationNotAuthenticated) {
                  return _AuthForm();
                }
                if (state is AuthenticationFailure ||
                    state is SessionExpiredState) {
                  var msg = (state as AuthenticationFailure).message;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(msg),
                        TextButton(
                          //textColor: Theme.of(context).primaryColor,
                          child: Text('Retry'),
                          onPressed: () {
                            authBloc.add(AppLoaded());
                          },
                        )
                      ],
                    ),
                  );
                }
                // return splash screen
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authService = getIt<JwtAuthenticationService>();
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    // ignore: no_leading_underscores_for_local_identifiers
    _onLoginButtonPressed() {
      if (_key.currentState!.validate()) {
        loginBloc.add(LoginInWithUserNameButtonPressed(
            username: _usernameController.text,
            password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _key,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://img.freepik.com/vector-premium/balon-futbol-estilo-dibujos-animados-aislado-fondo-blanco-balon-futbol-icono-deporte-juegos_566734-174.jpg',
                        width: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          'PLAYFUTDAY',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      isDense: true,
                    ),
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      isDense: true,
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null) {
                        return '...';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                      child: Text(
                        '¿You do not have count? Register now',
                        style: TextStyle(color: Colors.brown),
                      ),
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterForm(
                                  registerRepository: RegisterRepository()),
                            ),
                          )),
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        // ignore: sort_child_properties_last
                        child: state is LoginLoading
                            ? CircularProgressIndicator()
                            : Text('LOGIN'),
                        onPressed: state is LoginLoading
                            ? () {}
                            : _onLoginButtonPressed,
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showError(String error) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        error,
        style: TextStyle(
            color: Color.fromARGB(255, 247, 247, 247),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Color.fromARGB(255, 6, 12, 100),
    ));
  }
}

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
    debugPrint(varifyPassword.value);
    debugPrint(showSuccessResponse.value.toString());

    RegisterRepository().doRegister(username.value, email.value, phone.value,
        password.value, varifyPassword.value);
    await Future<void>.delayed(const Duration(seconds: 2));

    final response = await RegisterRepository().doRegister(username.value,
        email.value, phone.value, password.value, varifyPassword.value);

    if (response.statusCode != 400 ) {
      emitSuccess();
    } else {
      if (response.statusCode == 400) {
        final errorJson = json.decode(response.body);
        final subErrors = errorJson['subErrors'] ?? [];
        final errorMessages = subErrors.map((e) => e['message']).toList();
        final errorMessage = 'Validation error: ${errorMessages.join(', ')}';
        emitFailure(failureResponse: errorMessage);
      }
    }
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key, required this.registerRepository})
      : super(key: key);
  final RegisterRepository registerRepository;

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
              title: const Text('Register'),
              backgroundColor: Colors.green,
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
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.green),
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
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.green),
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
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            prefixIcon:
                                const Icon(Icons.phone, color: Colors.green),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFieldBlocBuilder(
                          textFieldBloc: regFormBloc.password,
                          suffixButton: SuffixButton.obscureText,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.green),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFieldBlocBuilder(
                          textFieldBloc: regFormBloc.varifyPassword,
                          suffixButton: SuffixButton.obscureText,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: 'Verify Password',
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.green),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: regFormBloc.submit,
                          child: const Text('Register'),
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
