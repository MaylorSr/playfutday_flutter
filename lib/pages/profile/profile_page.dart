// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/export.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileBloc _bloc;

  const ProfileScreen(this._bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: _bloc, // Dispatch LoadProfileEvent when the widget is built
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [/*
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/profile_picture.jpg'),
              ),*/
              SizedBox(height: 16.0),
              Text(
                state.username,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                state.biography,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                child: Text('Editar perfil'),
                onPressed: () => _bloc.add(EditProfileEvent()),
              ),
              Divider(),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  children: state.myPost
                      .map((image) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('image'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
