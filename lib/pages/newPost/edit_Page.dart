// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../blocs/photo/photo_bloc.dart';
import '../../blocs/photo/route/route_nanme.dart';

class EditPhotoPage extends StatefulWidget {
  final File image;

  const EditPhotoPage({Key? key, required this.image}) : super(key: key);

  @override
  _EditPhotoPageState createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  late File imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.image;

    if (imageFile != null) _cropImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<Null> _cropImage() async {
    //File croppedFile = await ImageCropper.cropImage(
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            hideBottomControls: true,
            showCropGrid: true,
            lockAspectRatio: false),
      ],
    );
    if (croppedFile != null) {
      //imageFile = croppedFile;
      imageFile = File(croppedFile.path);
      //context.bloc<PhotoBloc>().add(GetPhoto(imageFile));
      BlocProvider.of<PhotoBloc>(context).add(GetPhoto(imageFile));
      Navigator.pop(context, routeHome);
    }
  }
}
