

import 'package:car_shop/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../db/store_helper.dart';
import '../models/product.dart';

abstract class AppState {}

class INITIAL extends AppState {}

class LOADING extends AppState {}

class ERROR extends AppState {
  String error;
  ERROR(this.error);
}

class LoginState extends AppState {
  UserCredential? userCredential;
  LoginState(this.userCredential);
}

class RegisterState extends AppState {
  UserCredential? userCredential;
  RegisterState(this.userCredential);
}

class AccountState extends AppState {
  bool isCreated;
  AccountState(this.isCreated);
}

class ResetState extends AppState {
  bool isSuccess;
  ResetState(this.isSuccess);
}

class AuthState extends AppState {
  User? user;
  AuthState(this.user);
}

class UserInfoState extends AppState {
  UserModel? userModel;
  UserInfoState(this.userModel);
}

class GetProductsState extends AppState {
  List<Product>? list;
  GetProductsState(this.list);
}

class GetProductState extends AppState {
  Product? product;
  GetProductState(this.product);
}

/////////////

class GetCartItemsState extends AppState {
  List<StoreData> data;
  GetCartItemsState(this.data);
}

class GetSaveCartState extends AppState {
  int result;
  GetSaveCartState(this.result);
}

class GetDeleteCartItemState extends AppState {
  int result;
  GetDeleteCartItemState(this.result);
}

class GetDeleteCartState extends AppState {
  int result;
  GetDeleteCartState(this.result);
}

class GetTotalPriceState extends AppState {
  double totalPrice;
  GetTotalPriceState(this.totalPrice);
}

class GetUpdateCartState extends AppState {
  int result;
  GetUpdateCartState(this.result);
}

class GetThemeState extends AppState {
  ThemeMode themeMode;
  GetThemeState(this.themeMode);
}


