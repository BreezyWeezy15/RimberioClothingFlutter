
import 'dart:async';

import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/api_service.dart';

class AppBloc extends Bloc<AppEvent,AppState> {


  AuthService authService;
  AppBloc(this.authService) : super(INITIAL()){
    on<LoginEvent>((event, emit) => _loginUser(event, emit));
    on<RegisterEvent>((event, emit) => _registerUser(event, emit));
    on<AccountEvent>((event, emit) => _createAccount(event, emit));
    on<ResetEvent>((event, emit) => _resetUser(event, emit));
    on<AuthEvent>((event, emit) => _getStatus(event, emit));
    on<UserInfoEvent>((event, emit) => _getUserInfo(event, emit));
  }

  _loginUser(LoginEvent event,Emitter<AppState> emit) async {
    try {
      emit(LOADING());
      UserCredential? userCredential  = await authService.loginUser(event.email, event.pass);
      if(userCredential != null){
        emit(LoginState(userCredential));
      } else {
        emit(LoginState(null));
      }
    } catch(e){
      emit(ERROR(e.toString()));
    }
  }
  _registerUser(RegisterEvent event,Emitter<AppState> emit) async {
    try {
      emit(LOADING());
      UserCredential? userCredential  = await authService.registerUser(event.email, event.pass);
      if(userCredential != null){
        emit(RegisterState(userCredential));
      } else {
        emit(RegisterState(null));
      }
    } catch(e){
      emit(ERROR(e.toString()));
    }
  }
  _createAccount(AccountEvent event,Emitter<AppState> emit) async {
    try {
      await authService.createAccount(event.fullName,event.phone,event.email,event.address);
      emit(AccountState(true));
    } catch(e){
      emit(AccountState(false));
    }
  }
  _resetUser(ResetEvent event,Emitter<AppState> emit) async {
    try {
      emit(LOADING());
      await authService.resetPass(event.email);
      emit(ResetState(true));
    } catch(e){
      emit(ResetState(false));
    }
  }
  _getStatus(AuthEvent event, Emitter<AppState> emit) async {
    emit(LOADING());
    User? user = authService.userStatus();
    emit(AuthState(user));
  }
  _getUserInfo(UserInfoEvent event, Emitter<AppState> emit) async {
    emit(UserInfoState(await authService.getUser()));
  }

}
