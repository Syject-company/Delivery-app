import 'package:twsl_flutter/src/model/constants/delivery_status.dart';
import 'package:twsl_flutter/src/model/constants/order_time.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';

class OrderItem {
  final String? id;
  final DateTime? creationDate;
  final double? orderPrice;
  final double? pickUpPointLongitude;
  final double? pickUpPointLatitude;
  final String? pickUpAddress;
  final double? deliveryPointLongitude;
  final double? deliveryPointLatitude;
  final String? deliveryPointAddress;
  final String? customerName;
  final String? customerPhoneNumber;
  final String? companyName;
  final String? companyPhoneNumber;
  final String? companyPostalCode;
  final String? companyAddress;
  final String? companyImageUrl;
  OrderTime? orderTime;
  DateTime? orderDate;

  final bool isImportant = false;
  DeliveryStatus orderStatus;
  final bool? paymentStatusForDriver;

  OrderItem.all(
    this.id,
    this.creationDate,
    this.orderPrice,
    this.pickUpPointLongitude,
    this.pickUpPointLatitude,
    this.pickUpAddress,
    this.deliveryPointLongitude,
    this.deliveryPointLatitude,
    this.deliveryPointAddress,
    this.customerName,
    this.customerPhoneNumber,
    this.companyName,
    this.companyPhoneNumber,
    this.companyPostalCode,
    this.companyAddress,
    this.companyImageUrl,
    this.orderStatus,
    this.orderTime,
    this.orderDate,
    this.paymentStatusForDriver,
  );

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem.all(
        map["id"],
        DateTime.tryParse(map["creationDate"] ?? ''),
        map["orderPrice"],
        map["pickUpPointLongitude"],
        map["pickUpPointLatitude"],
        map["pickUpAddress"],
        map["deliveryPointLongitude"],
        map["deliveryPointLatitude"],
        map["deliveryAddress"],
        map["customerName"],
        map["customerPhoneNumber"],
        map["companyName"],
        map["companyPhoneNumber"],
        map["companyPostalCode"],
        map["companyAddress"],
        map["companyImageUrl"],
        DeliveryStatusResources.converterStringToStatus(map["orderStatus"]),
        OrderTimeResources.orderTimeFromString(map["orderTime"]),
        DateTime.tryParse(map["orderDate"] ?? ''),
        map["paymentStatusForDriver"],
      );
}

class DeliveryMoment {
  OrderTime? orderTime;
  DateTime? orderDate;

  DeliveryMoment.all(this.orderTime, this.orderDate);

  Map<String, dynamic> toMap() => {
        "orderTime": OrderTimeResources.orderTimeToString(orderTime),
        "orderDate": orderDate!.getFormattedDateForBack(),
      };
}
