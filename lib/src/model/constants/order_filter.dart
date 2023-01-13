enum OrderFilter { all, readyForDelivery, inDelivery }

class OrderFilterResources {
  static String orderFilterToString(OrderFilter filter) {
    return orderFilterText(filter).replaceAll(" ", "");
  }

  static String orderFilterText(OrderFilter filter) {
    switch (filter) {
      case OrderFilter.all:
        return "All";
      case OrderFilter.readyForDelivery:
        return "Ready For Delivery";
      case OrderFilter.inDelivery:
        return "In Delivery";
      default:
        return "All";
    }
  }
}
