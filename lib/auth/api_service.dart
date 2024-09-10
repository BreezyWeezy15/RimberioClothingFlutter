


import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../db/store_helper.dart';
import '../models/user_model.dart';

class AuthService {


  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;


  // login user
  Future<UserCredential?> loginUser(String email , String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  // register user
  Future<UserCredential?> registerUser(String email,String password) async {
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // register user
  Future createAccount(String fullName , String phone,
      String email , String address) async {

    var map = HashMap();
    map['fullName'] = fullName;
    map['phone'] = phone;
    map['email'] = email;
    map['address'] = address;
    map['userId'] = firebaseAuth.currentUser!.uid;
    map['profileUrl'] = "https://firebasestorage.googleapis.com/v0/b/rimberio-296b9.appspot.com/o/profile.png?alt=media&token=4ffedad9-0318-46db-808c-a64b7ba6bf75";

    return await firebaseDatabase.ref().child('Users').child(firebaseAuth.currentUser!.uid).set(map);
  }

   // reset pass
  Future<void> resetPass(String email) async {
      return await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  User? userStatus(){
    return firebaseAuth.currentUser;
  }


  Future<UserModel?> getUser() async {
    final snapshot = await firebaseDatabase
        .ref()
        .child('Users')
        .child(firebaseAuth.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> map =  Map<String, dynamic>.from(snapshot.value as Map);
      return UserModel(
        fullName: map['fullName'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        address: map['address'] ?? '',
        profileUrl: map['profileUrl'] ?? '',
        userUid: map['userUid'] ?? '',
      );
    } else {
      return null;
    }
  }

  //
   uploadInvoice(List<StoreData> list, String totalPrice) async {
    var invoiceID = DateTime.now().millisecondsSinceEpoch.toString();

    DateFormat dateFormat = DateFormat();
    String dateTime = dateFormat.format(DateTime.now());

    var invoiceData = list.map((e) => e.toJson()).toList();

    var invoiceMap = {
      "data": invoiceData,
      "invoiceID" : invoiceID,
      "paid" : dateTime,
      "userUid" : firebaseAuth.currentUser!.uid,
      "totalPrice": totalPrice
    };

     await firebaseDatabase
        .ref()
        .child("Invoices")
        .child(firebaseAuth.currentUser!.uid)
        .child(invoiceID)
        .set(invoiceMap);
  }

  Future<DataSnapshot> getInvoices() async {
    return await firebaseDatabase
        .ref()
        .child("Invoices")
        .child(firebaseAuth.currentUser!.uid).get();
  }

}
