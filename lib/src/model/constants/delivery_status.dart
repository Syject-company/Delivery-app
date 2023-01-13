import 'package:flutter/material.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';

enum DeliveryStatus {
  expired,
  created,
  waitingConfirmationUser,
  readyForDelivery,
  inDelivery,
  delivered,
  completed,
}

class DeliveryStatusResources {
  static DeliveryStatusData getValue(DeliveryStatus status, BuildContext ctx) {
    switch (status) {
      case DeliveryStatus.waitingConfirmationUser:
        return DeliveryStatusData(
          "Ready For Delivery".localize(ctx),
          "B4BBCA".getColor(),
          Colors.white,
          "assets/icons/ready_delivery.svg",
          ["FDBE01".getColor(), "FC7F01".getColor()],
        );
      case DeliveryStatus.readyForDelivery:
        return DeliveryStatusData(
          "Ready For Delivery".localize(ctx),
          "FFEFDD".getColor(),
          "FC8501".getColor(),
          "assets/icons/ready_delivery.svg",
          ["FDBE01".getColor(), "FC7F01".getColor()],
        );
      case DeliveryStatus.inDelivery:
        return DeliveryStatusData(
          "In Delivery".localize(ctx),
          "E4F8FD".getColor(),
          "13B5DB".getColor(),
          "assets/icons/in_delivery.svg",
          ["50E5CB".getColor(), "06ABDF".getColor()],
        );
      case DeliveryStatus.delivered:
        return DeliveryStatusData(
          "Delivered".localize(ctx),
          "DFFFEE".getColor(),
          "4EBC7F".getColor(),
          "assets/icons/delivered.svg",
          ["8EE078".getColor(), "38B081".getColor()],
        );
      default:
        return DeliveryStatusData(
          "Ready For Delivery".localize(ctx),
          "FFEFDD".getColor(),
          "FC8501".getColor(),
          "assets/icons/ready_delivery.svg",
          ["FDBE01".getColor(), "FC7F01".getColor()],
        );
    }
  }

  static String converterStatusToString(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.created:
        return "Created";
      case DeliveryStatus.waitingConfirmationUser:
        return "WaitingConfirmationUser";
      case DeliveryStatus.readyForDelivery:
        return "ReadyForDelivery";
      case DeliveryStatus.inDelivery:
        return "InDelivery";
      case DeliveryStatus.delivered:
        return "Delivered";
      case DeliveryStatus.completed:
        return "Completed";
      case DeliveryStatus.expired:
        return "Expired";
      default:
        return "Expired";
    }
  }

  static DeliveryStatus converterStringToStatus(String? status) {
    switch (status) {
      case "Created":
        return DeliveryStatus.created;
      case "WaitingConfirmationUser":
        return DeliveryStatus.waitingConfirmationUser;
      case "ReadyForDelivery":
        return DeliveryStatus.readyForDelivery;
      case "InDelivery":
        return DeliveryStatus.inDelivery;
      case "Delivered":
        return DeliveryStatus.delivered;
      case "Completed":
        return DeliveryStatus.completed;
      case "Expired":
        return DeliveryStatus.expired;
      default:
        return DeliveryStatus.expired;
    }
  }
}

class DeliveryStatusData {
  String text;
  Color backgroundColor;
  Color textColor;
  String iconSvgAssetPath;
  List<Color> gradientBackgroundColors;

  DeliveryStatusData(this.text, this.backgroundColor, this.textColor,
      this.iconSvgAssetPath, this.gradientBackgroundColors);
}
