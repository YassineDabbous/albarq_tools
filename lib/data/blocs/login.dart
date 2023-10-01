import 'package:albarq_tools/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  Profile data;
  LoginSuccess({required this.data});
}

class LoginFailed extends LoginState {
  String message;
  LoginFailed({required this.message});
}

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(LoginInitial());

  login({required String phone, required String password}) async {
    emit(LoginLoading());
    Repository.http().login(Login(phone: phone, password: password)).then((value) {
      if (value.data != null) {
        emit(LoginSuccess(data: value.data!));
        AuthManager().setCurrentUser(value.data!);
      }
    }).catchError((e) {
      emit(LoginFailed(message: e.toString()));
    });
  }
}
