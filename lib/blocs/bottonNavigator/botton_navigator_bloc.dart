import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, int> {
  BottomNavigationBloc() : super(1) {
    on<TabChangeEvent>((event, emit) => emit(event.newIndex));
  }
}
