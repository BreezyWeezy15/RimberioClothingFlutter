

import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/main.dart';
import 'package:car_shop/models/order/order_model.dart';
import 'package:car_shop/others/theme_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/api_service.dart';

class AppBloc extends Bloc<AppEvent,AppState> {

  AppBloc() : super(INITIAL()){
    on<LoginEvent>((event, emit) => _loginUser(event, emit));
    on<RegisterEvent>((event, emit) => _registerUser(event, emit));
    on<AccountEvent>((event, emit) => _createAccount(event, emit));
    on<ResetEvent>((event, emit) => _resetUser(event, emit));
    on<AuthEvent>((event, emit) => _getStatus(event, emit));
    on<UserInfoEvent>((event, emit) => _getUserInfo(event, emit));
    on<GetThemeEvent>((event, emit) => _changeTheme(event, emit));
    on<GetUploadInvoiceEvent>((event,emit) => _uploadInvoice(event, emit));
    on<GetOrdersEvent>((event,emit) => _getOrders(event, emit));
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


  _changeTheme(GetThemeEvent event,Emitter<AppState> emit) {
     ThemeMode themeMode = ThemeHelper.getTheme();
     emit(GetThemeState(themeMode));
  }

  _uploadInvoice(GetUploadInvoiceEvent event , Emitter<AppState> emit) async {
    try {
      await authService.uploadInvoice(event.list, event.totalPrice);
      emit(GetUploadInvoiceState(true,"No Error"));
    } catch(e){
      emit(GetUploadInvoiceState(false,e.toString()));
    }
  }

  _getOrders(GetOrdersEvent event, Emitter<AppState> emit) async {
    try {
      DataSnapshot dataSnapshot = await authService.getInvoices();
      if (dataSnapshot.exists) {
        List<OrderModel> orders = [];
        for (var shot in dataSnapshot.children) {
          var data = Map<String?, dynamic>.from(shot.value as Map);
          OrderModel order = OrderModel.fromMap(data);
          orders.add(order);
        }
        emit(GetInvoicesState(orders));
      } else {
        emit(ERROR("No orders found"));
      }
    } catch (e) {
      emit(ERROR(e.toString()));
    }
  }

}
