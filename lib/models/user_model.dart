


class UserModel {

  String fullName;
  String email;
  String phone;
  String address;
  String profileUrl;
  String userUid;

  UserModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.profileUrl,
    required this.userUid,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      userUid: json['userUid'] ?? '',
    );
  }

  Map<String,dynamic> toJson() => {
    "fullName" : fullName,
    "email" : email,
    "phone" : phone,
    "address" : address,
    "profileUrl" : profileUrl,
    "userUid" : userUid,
  };


}
