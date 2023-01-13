import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/constants/order_time.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/profile/delivery_details/delivery_details_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  @override
  _DeliveryDetailsScreen createState() => _DeliveryDetailsScreen();
}

class _DeliveryDetailsScreen extends State<DeliveryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<DeliveryDetailsModel>(context, listen: false);
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    model.item = arguments["item"];
    return Directionality(
      textDirection: getTextDirection(context),
      child: Scaffold(
        appBar: AppBar(
          title: text16w500(
            "Details".localize(context),
            color: "454F63".getColor(),
          ),
        ),
        body: SingleChildScrollView(child: body(context, model.item!)),
      ),
    );
  }

  Widget body(BuildContext context, OrderItem item) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 34),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 32, 20, 35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text14And500WithColor("Trip ID".localize(context), "959DAD"),
                text14And500WithColor("Time".localize(context), "959DAD"),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text14And400(item.id!),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      text12And400(item.orderDate!.getFormattedDateTime()),
                      text12And400(
                        OrderTimeResources.orderTimeToString(item.orderTime),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: (item.companyImageUrl != null
                        ? NetworkImage(item.companyImageUrl!)
                        : AssetImage("assets/images/no_logo.png")) as ImageProvider<Object>?,
                    radius: 24,
                  ),
                  Text(
                    "${"SAR".localize(context)} ${item.orderPrice}",
                    style: TextStyle(color: "BD2755".getColor()),
                  )
                ],
              ),
            ),
            text14And500(item.companyName!),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: text14And400WithColor(
                  item.companyAddress!, "959DAD".getColor()),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  height: POINT_HEIGHT,
                  // width: 160,
                  decoration: BoxDecoration(
                    color: "F02E39".getColor(),
                    borderRadius: BorderRadius.circular(POINT_HEIGHT / 2),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/ellipse.svg",
                          color: Colors.white),
                      const SizedBox(width: 12),
                      text14And400WithColor(
                        "Pick up point".localize(context),
                        Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            text14And400(item.pickUpAddress!),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: const Divider(height: 1),
            ),
            Row(
              children: [
                Container(
                  height: POINT_HEIGHT,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                    color: "38B081".getColor(),
                    borderRadius: BorderRadius.circular(POINT_HEIGHT / 2),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/triangle.svg",
                          color: Colors.white),
                      const SizedBox(width: 12),
                      text14And400WithColor(
                        "Delivery point".localize(context),
                        Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: text14And400(
                "${"Name:".localize(context)} ${item.customerName}",
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: text14And400(item.deliveryPointAddress!),
            ),
          ],
        ),
      ),
    );
  }

  static const POINT_HEIGHT = 30.0;
}
