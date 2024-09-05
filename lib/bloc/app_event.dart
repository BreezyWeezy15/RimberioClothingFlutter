

import 'package:car_shop/views/register_page.dart';

import '../db/store_helper.dart';

abstract class AppEvent {}


class LoginEvent extends AppEvent {
  String email;
  String pass;

  LoginEvent(this.email,this.pass);
}
class RegisterEvent extends AppEvent {
  String email;
  String pass;

  RegisterEvent(this.email,this.pass);

}

class AccountEvent extends AppEvent {
  String fullName;
  String phone;
  String email;
  String address;

  AccountEvent(this.fullName,this.phone,this.email,this.address);
}

class ResetEvent extends AppEvent {
  String email;

  ResetEvent(this.email);
}

class AuthEvent extends AppEvent {

}

class UserInfoEvent extends AppEvent {

}

class GetProductsEvent extends AppEvent {
  String productCategory;
  GetProductsEvent(this.productCategory);
}

class GetProductEvent extends AppEvent {
  int productId;
  GetProductEvent(this.productId);
}

class GetCartItemsEvent extends AppEvent {

}

class GetSaveCartEvent extends AppEvent {
  StoreCompanion companion;
  GetSaveCartEvent(this.companion);
}

class GetDeleteCartItemEvent extends AppEvent {
  int itemId;
  GetDeleteCartItemEvent(this.itemId);
}

class GetDeleteCartEvent extends AppEvent {

}
