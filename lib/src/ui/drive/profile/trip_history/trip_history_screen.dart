import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/constants/delivery_status.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/profile/trip_history/trip_history_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class TripHistoryScreen extends StatefulWidget {
  @override
  _TripHistoryScreen createState() => _TripHistoryScreen();
}

class _TripHistoryScreen extends State<TripHistoryScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<TripHistoryModel>(context, listen: false);
    return Directionality(
      textDirection: getTextDirection(context),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: text16w500(
            "Trip History".localize(context),
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
            ),
          ),
          bottom: toolbarBottom(context) as PreferredSizeWidget?,
        ),
        body: Consumer<TripHistoryModel>(
          builder: (context, data, _) {
            var tripsFiltered = [];
            if (tabController!.index == 0) {
              tripsFiltered.clear();
              tripsFiltered.addAll(model.trips);
            } else {
              model.trips.forEach((element) {
                if (tabController!.index == 1) {
                  if (element.paymentStatusForDriver!) {
                    tripsFiltered.add(element);
                  }
                }

                if (tabController!.index == 2) {
                  if (!element.paymentStatusForDriver!) {
                    tripsFiltered.add(element);
                  }
                }
              });
            }

            if (tripsFiltered.isEmpty) {
              return Center(
                child: text14And600WithColor(
                  getEmptyMessage(context),
                  "454F63".getColor(),
                ),
              );
            } else {
              return ListView.builder(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  itemCount: tripsFiltered.length,
                  itemBuilder: (context, index) {
                    return item(context, model, tripsFiltered[index]);
                  });
            }
          },
        ),
      ),
    );
  }

  String getEmptyMessage(BuildContext context) {
    late String message;
    switch (tabController!.index) {
      case 0:
        message = "You don't have trips yet";
        break;
      case 1:
        message = "You have no paid rides";
        break;
      case 2:
        message = "You have no unpaid rides";
        break;
    }
    return message.localize(context);
  }

  Widget item(BuildContext context, TripHistoryModel model, OrderItem item) {
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
              arguments: {"item": item},
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text12And400(item.orderDate!.getFormattedDateTime()),
                    Column(
                      children: [
                        text12And400("Trip ID:".localize(context)),
                        text14And400(item.id!),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: "BD2755".getColor()),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: text12And400AndColor(
                        "SAR".localize(context) + " ${item.orderPrice}",
                        "BD2755",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: (item.companyImageUrl != null
                          ? NetworkImage(item.companyImageUrl!)
                          : AssetImage("assets/images/no_logo.png")) as ImageProvider<Object>?,
                      backgroundColor: Colors.white,
                      radius: 24,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset("assets/icons/ellipse.svg"),
                              const SizedBox(width: 12),
                              Flexible(child: text12And400(item.pickUpAddress!)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SvgPicture.asset("assets/icons/triangle.svg"),
                              const SizedBox(width: 12),
                              Flexible(
                                  child:
                                      text12And400(item.deliveryPointAddress!)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 58),
                  child: text12And400AndColor(
                    DeliveryStatusResources.converterStatusToString(
                        item.orderStatus),
                    item.orderStatus == DeliveryStatus.completed
                        ? "27AE60"
                        : "EB5757",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget toolbarBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(161),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            text16w400(
              "Total".localize(context),
              color: Colors.white,
              align: null,
            ),
            Text(
              "SAR 27.347",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                labelColor: Colors.white,
                controller: tabController,
                labelPadding: EdgeInsets.all(0),
                unselectedLabelColor: "454F63".getColor(),
                onTap: (index) {
                  Provider.of<TripHistoryModel>(context, listen: false)
                      .notifyListeners();
                },
                indicator: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        "FDBE01".getColor(),
                        "FC7F01".getColor(),
                      ],
                    ),
                    border: Border.all(color: Colors.white, width: 4),
                    borderRadius: BorderRadius.circular(24)),
                tabs: [
                  Tab(
                    text: "All".localize(context),
                  ),
                  Tab(
                    text: "Paid".localize(context),
                  ),
                  Tab(
                    text: "Unpaid".localize(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
