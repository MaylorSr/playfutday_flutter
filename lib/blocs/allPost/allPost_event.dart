// ignore: file_names
import 'package:equatable/equatable.dart';

abstract class AllPostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllPostFetched extends AllPostEvent {}
