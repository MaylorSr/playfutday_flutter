// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../blocs/photo/photo_bloc.dart';
import '../../blocs/photo/route/route_nanme.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  late File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Tag',
                filled: true,
                isDense: true,
              ),
              /*controller: _usernameController,*/
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
                isDense: true,
              ),
              obscureText: false,
              /*
                    controller: _passwordController,*/
              validator: (value) {
                if (value == null) {
                  return 'Password is required.';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _showSelectionDialog();
                  },
                  child: BlocBuilder<PhotoBloc, PhotoState>(
                    //cubit: BlocProvider.of<PhotoBloc>(
                    bloc: BlocProvider.of<PhotoBloc>(
                        context), // provide the local bloc instance
                    builder: (context, state) {
                      return Container(
                        height: 150,
                        width: 150,
                        child: state is PhotoInitial
                            ? Image.asset(
                                'assets/images/user.png') // set a placeholder image when no photo is set
                            : Image.file((state as PhotoSet).photo),
                      );
                    },
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  'Please select your profile photo',
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  // color: Theme.of(context).primaryColor,
                  //textColor: Colors.white,
                  //padding: const EdgeInsets.all(16),
                  // ignore: sort_child_properties_last
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  onPressed: () {},
                  child: Text(
                      'Add Post'), /*
                        onPressed: state is LoginLoading
                            ? () {}
                            : _onLoginButtonPressed,
                      */
                )),
          ],
        ),
      ),
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.pushNamed(context as BuildContext, routeEdit,
            arguments: _image);
      } else
        print('No photo was selected or taken');
    });
  }

  /// Selection dialog that prompts the user to select an existing photo or take a new one
  Future _showSelectionDialog() async {
    await showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Select photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('From gallery'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.gallery);
              Navigator.pop(context as BuildContext);
            },
          ),
          SimpleDialogOption(
            child: Text('Take a photo'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.camera);
              Navigator.pop(context as BuildContext);
            },
          ),
        ],
      ),
    );
  }
}