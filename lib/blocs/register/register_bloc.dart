import 'package:bloc/bloc.dart';
import 'package:playfutday_flutter/blocs/register/register_event.dart';
import 'package:playfutday_flutter/blocs/register/register_state.dart';
import 'package:playfutday_flutter/repositories/register_repositories/register_repositoy.dart';
import '../../rest/rest_client.dart';
import '../authentication/authentication.dart';
import '../../services/services.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository __registerRepositoy;
  RegisterBloc(super.initialState, this.__registerRepositoy) {
    on<RegisterInPressed>(__RegisterInPressed);
  }

  // ignore: non_constant_identifier_names
  __RegisterInPressed(
    RegisterInPressed event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final newUser = await __registerRepositoy.doRegister(event.username,
          event.password, event.veryfyPassword, event.email, event.phone);
      if (newUser) {
        emit(RegisterSuccess());
        emit(RegisterInitial());
      } else {
        emit(RegisterFailure(error: 'Something very weird just happened'));
      }
    } on AuthenticationException catch (e) {
      emit(RegisterFailure(error: e.message));
    } on CustomException catch (err) {
      emit(RegisterFailure(error: 'An unknown error occurred ${err.message}'));
    }
  }
}
