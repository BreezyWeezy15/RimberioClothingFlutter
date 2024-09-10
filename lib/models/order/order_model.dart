
import 'order_item.dart';

class OrderModel {
  final List<OrderItem> data;
  final String invoiceID;
  final String paid;
  final String totalPrice;
  final String userUid;

  OrderModel({
    required this.data,
    required this.invoiceID,
    required this.paid,
    required this.totalPrice,
    required this.userUid,
  });

  // Convert OrderModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'data': data.map((item) => item.toMap()).toList(),
      'invoiceID': invoiceID,
      'paid': paid,
      'totalPrice': totalPrice,
      'userUid': userUid,
    };
  }

  // Create OrderModel from a Map
  factory OrderModel.fromMap(Map<dynamic, dynamic> map) {
    return OrderModel(
      data: List<OrderItem>.from(map['data'].map((item) => OrderItem.fromMap(item))),
      invoiceID: map['invoiceID'],
      paid: map['paid'],
      totalPrice: map['totalPrice'],
      userUid: map['userUid'],
    );
  }
}
