enum OrderTime { none, morning, afternoon, evening }

class OrderTimeResources {
  static String orderTimeToString(OrderTime? orderTime) {
    switch (orderTime) {
      case OrderTime.none:
        return "None";
      case OrderTime.morning:
        return "Morning";
      case OrderTime.afternoon:
        return "Afternoon";
      case OrderTime.evening:
        return "Evening";
      default:
        return "None";
    }
  }

  static OrderTime orderTimeFromString(String? orderTime) {
    switch (orderTime) {
      case "None":
        return OrderTime.none;
      case "Morning":
        return OrderTime.morning;
      case "Afternoon":
        return OrderTime.afternoon;
      case "Evening":
        return OrderTime.evening;
      default:
        return OrderTime.none;
    }
  }
}
