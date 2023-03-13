// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, unused_local_variable, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';

import '../../models/user.dart';

class EditProfile extends StatefulWidget {
  final User user;
  final UserService userService;

  const EditProfile({super.key, required this.user, required this.userService});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileState createState() => _EditProfileState();
}

class SerializedFormBloc extends FormBloc<String, String> {
  final birthDate = InputFieldBloc<DateTime?, Object>(
    name: 'birthDate',
    initialValue: DateTime.now(),
    toJson: (value) =>
        value == null ? null : DateFormat('dd/MM/yyyy').format(value),
  );

  SerializedFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        birthDate,
      ],
    );
  }

  @override
  void onSubmitting() async {
    emitSuccess(
      canSubmitAgain: true,
      successResponse: const JsonEncoder.withIndent('    ').convert(
        state.toJson(),
      ),
    );
  }
}

class _EditProfileState extends State<EditProfile> {
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  late final ImagePicker _imagePicker;
  final String url_base = "http://localhost:8080/download/";
  // ignore: unused_field
  DateTime? _selectedDate;
  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.user.phone);
    _bioController = TextEditingController(text: widget.user.biography);
    _imagePicker = ImagePicker();
    _selectedDate = DateFormat('dd/MM/yyyy').parse(widget.user.birthday!);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<bool> _validatePhone() async {
    final response = await UserService().editPhone(_phoneController.text);
    if (response!.statusCode == 400) {
      final errorJson = json.decode(response.body);
      final subErrors = errorJson['subErrors'] ?? [];
      final errorMessages = subErrors.map((e) => e['message']).toList();
      final errorMessage = 'Validation error: ${errorMessages.join(', ')}';
      // Mostrar mensaje de error al usuario
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
    setState(() {
      widget.user.phone = _phoneController.text;
      widget.userService.editPhone(_phoneController.text);
    });
    return true;
  }

  void _updateProfile() async {
    final updatedUser = User(
        biography: _bioController.text,
        phone: _phoneController.text,
        birthday: DateFormat('dd/MM/yyyy').format(_selectedDate!)

        // set other fields as necessary
        );
    setState(() {
      widget.user.biography = _bioController.text;
      widget.userService.editBio(_bioController.text);
      widget.user.birthday = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      widget.userService
          .editBirthday(DateFormat('dd/MM/yyyy').format(_selectedDate!));

      _validatePhone();
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  void _selectImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // TODO: handle selected image
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SerializedFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<SerializedFormBloc>();

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('Edit Profile'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      _updateProfile();
                    },
                  ),
                ],
              ),
              body: FormBlocListener<SerializedFormBloc, String, String>(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: _selectImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                    '${url_base}${widget.user.avatar}'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        TextFormField(
                          controller: _bioController,
                          decoration: InputDecoration(
                            labelText: 'Biography',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                          maxLines: null,
                          maxLength: 200,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            prefixIcon: Icon(Icons.phone_callback),
                          ),
                          maxLength: 9,
                        ),
                        SizedBox(height: 16),
                        DateTimeFieldBlocBuilder(
                          dateTimeFieldBloc: formBloc.birthDate,
                          format: DateFormat('dd-MM-yyyy'),
                          initialDate: _selectedDate!,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
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

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
                height:
                    10), /*
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  
                  MaterialPageRoute(builder: (_) =>  _EditProfileState())
                  ),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),*/
          ],
        ),
      ),
    );
  }
}
