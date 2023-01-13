import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/profile/payment_history/payment_history_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreen createState() => _PaymentHistoryScreen();
}

class _PaymentHistoryScreen extends State<PaymentHistoryScreen> {
  StreamController<int> totalRidesStreamCon = BehaviorSubject();
  late double totalSar;

  DateTimeRange? filter;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentHistoryModel(Provider.of(context)),
      builder: (context, _) {
        return Directionality(
          textDirection: getTextDirection(context),
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: text16w500(
                "Payment History".localize(context),
                color: Colors.white,
              ),
              flexibleSpace: Container(
                  decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      "FDBE01".getColor(),
                      "FC7F01".getColor(),
                    ]),
              )),
              actions: [
                IconButton(
                  icon: SvgPicture.asset(
                    filter == null
                        ? "assets/icons/calendar.svg"
                        : "assets/icons/close.svg",
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (filter == null) {
                      showDateRangePicker(
                          context: context,
                          firstDate: DateTime(0),
                          lastDate: DateTime(9999),
                          locale: FlutterI18n.currentLocale(context),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: getColorFromHex("FC7F01"),
                              ),
                              child: child!,
                            );
                          }).then((value) {
                        setState(() {
                          filter = value;
                        });
                      });
                    } else {
                      setState(() {
                        filter = null;
                      });
                    }
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                Consumer<PaymentHistoryModel>(
                  builder: (context, data, _) {
                    var ordersRaw = data.orders;
                    List<OrderItem> orders = [];
                    totalSar = 0;
                    orders.clear();
                    ordersRaw.forEach((element) {
                      totalSar += element.orderPrice!;
                      if (filter != null) {
                        if (element.orderDate!.isAfter(filter!.start) &&
                            element.orderDate!.isBefore(filter!.end)) {
                          orders.add(element);
                        }
                      } else {
                        orders.add(element);
                      }
                    });
                    totalRidesStreamCon.sink.add(orders.length);
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 132, left: 16, right: 16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return item(context, orders[index], index);
                      },
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: StreamBuilder(
                      stream: totalRidesStreamCon.stream,
                      builder: (context, data) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 166,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    "FFC000".getColor(),
                                    "FB8C00".getColor()
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  text16w500(
                                    "Total Rides".localize(context),
                                    color: Colors.white,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      data.data?.toString() ?? "-",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 100,
                              width: 166,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    "00B0F0".getColor(),
                                    "1976D2".getColor()
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  text16w500(
                                    "Total Earn".localize(context),
                                    color: Colors.white,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'SAR ${totalSar.toStringAsFixed(2)}',
                                      // ignore: todo
                                      //TODO maybe line break (SAR)
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget item(BuildContext context, OrderItem order, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.DELIVERY_DETAILS,
              arguments: {"item": order},
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text16w400(order.orderDate!.getFormattedDate()),
                    text16w400(order.id!),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Divider(height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text16w400("Rides".localize(context),
                        color: "959DAD".getColor()),
                    text16w400("Paid".localize(context),
                        color: "959DAD".getColor()),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text16w500("${index + 1}", color: "37D09D".getColor()),
                    text16w500(
                      "SAR ${order.orderPrice!.toStringAsFixed(2)}",
                      color: "37D09D".getColor(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    totalRidesStreamCon.close();

    super.dispose();
  }
}
