// ignore_for_file: override_on_non_overriding_member

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc() : super(PhotoInitial()) {
    on<GetPhoto>(_onGetPhoto);
  }

  _onGetPhoto(
    GetPhoto event,
    Emitter<PhotoState> emit,
  ) {
    final photo = event.photo;
    if (event is GetPhoto) emit(PhotoSet(photo));
    throw Exception("You have to put a photo here!");
  }
}
