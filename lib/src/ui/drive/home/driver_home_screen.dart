import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/constants/delivery_status.dart';
import 'package:twsl_flutter/src/model/constants/order_filter.dart';
import 'package:twsl_flutter/src/model/constants/order_time.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/services/tracker_position_model.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/custom/bottom_anim_screen.dart';
import 'package:twsl_flutter/src/ui/drive/auth/user_model.dart';
import 'package:twsl_flutter/src/ui/drive/home/driver_home_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class DriverHomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<DriverHomeScreen> {
  BottomAnimScreen? bottomAnimScreen;

  @override
  Widget build(BuildContext context) {
    Provider.of<UserModel>(context, listen: false).getUser();
    return ChangeNotifierProvider(
      create: (_) => DriverHomeModel(Provider.of(context)),
      builder: (context, _) {
        if (bottomAnimScreen == null) {
          bottomAnimScreen = BottomAnimScreen(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(30),
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: getAppGradient(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Consumer<DriverHomeModel>(
                  builder: (context, data, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: items(
                        context,
                        getFilterItems(
                          context,
                          Provider.of<DriverHomeModel>(context).filter,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }

        return WillPopScope(
          onWillPop: bottomAnimScreen!.onWillPop,
          child: Directionality(
            textDirection: getTextDirection(context),
            child: Scaffold(
              body: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Stack(
                  children: [
                    _listWidgetsOrEmptyScreen(Provider.of(context)),
                    _header(context),
                    bottomAnimScreen!,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, HEADER_TOP_PADDING, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.DRIVER_PROFILE)
                          .then((value) {
                        setState(
                            // ignore: todo
                            () {}); //TODO need call when only was change language
                      });
                    },
                    child: Consumer<UserModel>(
                      builder: (context, data, _) {
                        var img = data.driver.value?.photoUri;
                        return ValueListenableProvider.value(
                            value: data.driver,
                            child: CircleAvatar(
                                backgroundImage: (img == null
                                        ? AssetImage(
                                            "assets/images/empty_profile.png")
                                        : NetworkImage(img))
                                    as ImageProvider<Object>?,
                                backgroundColor: Colors.white,
                                radius: USER_PROFILE_COVER_HEIGHT / 2));
                      },
                    ),
                  ),
                  Container(
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Text(""),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Consumer<DriverHomeModel>(
                    builder: (context, data, _) {
                      return Visibility(
                        visible: !(data.orders!.isEmpty &&
                            data.filter == OrderFilter.all),
                        child: SizedBox(
                          height: 36,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              switch (bottomAnimScreen!.controller.status) {
                                case AnimationStatus.completed:
                                  bottomAnimScreen!.closeScreen();
                                  break;
                                case AnimationStatus.dismissed:
                                  bottomAnimScreen!.openScreen();
                                  break;
                                default:
                              }
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                  child: Text(
                                    FlutterI18n.translate(context, "Filter"),
                                  ),
                                ),
                                SvgPicture.asset("assets/icons/filters.svg"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  Ink(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: InkWell(
                      onTap: () {
                        Provider.of<DriverHomeModel>(context, listen: false)
                            .loadOrders("HomeScreen header");
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset("assets/icons/reload.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          StreamBuilder(
            stream: Provider.of<DriverHomeModel>(context, listen: false)
                .isShowProgressController
                .stream,
            builder: (context, data) {
              return Visibility(
                visible: false, //data.data == true,
                child: LinearProgressIndicator(
                  backgroundColor: "F9E4EB".getColor(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _emptyScreen(String text1, String text2) {
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 60, 30, 60),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/empty_home.png"),
            Text(
              text1,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              text2,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listWidgetsOrEmptyScreen(DriverHomeModel model) {
    return Consumer<DriverHomeModel>(builder: (context, data, _) {
      if (data.orders!.isNotEmpty) {
        return ListView.builder(
          padding: EdgeInsets.only(top: LIST_TOP_PADDING),
          itemCount: data.orders!.length,
          itemBuilder: (context, index) {
            var item = data.orders![index];
            if (item.orderStatus == DeliveryStatus.inDelivery) {
              Provider.of<TrackerPositionModel>(context, listen: false)
                  .startTracking();
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: item.isImportant
                  ? importantItem(model, item)
                  : simpleItem(model, item),
            );
          },
        );
      }
      if (data.filter != OrderFilter.all) {
        return _emptyScreen(
          "Not orders.".localize(context),
          "Not available orders by checked filter".localize(context),
        );
      } else {
        return _emptyScreen(
          "Please wait!".localize(context),
          "No delivery requests yet".localize(context),
        );
      }
    });
  }

  Widget simpleItem(DriverHomeModel model, OrderItem item) {
    var deliveryItemResources =
        DeliveryStatusResources.getValue(item.orderStatus, context);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  text12And400(item.orderDate!.getFormattedDateTime()),
                  text12And400(
                    OrderTimeResources.orderTimeToString(item.orderTime),
                  ),
                ],
              ),
              Column(
                children: [
                  text12And400("Trip ID:".localize(context)),
                  text14And400(item.id!),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: getColorFromHex("BD2755")),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: text12And400AndColor(
                    FlutterI18n.translate(context, "SAR") +
                        " ${item.orderPrice}",
                    "BD2755"),
              ),
            ],
          ),
          Container(height: 10),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: (item.companyImageUrl != null
                        ? NetworkImage(item.companyImageUrl!)
                        : AssetImage("assets/images/no_logo.png"))
                    as ImageProvider<Object>?,
                backgroundColor: Colors.white,
                radius: 24,
              ),
              Container(width: 10),
              Flexible(child: text14And500(item.companyName!)),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/ellipse.svg"),
                Container(width: 12),
                Flexible(child: text12And400(item.pickUpAddress!)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 16),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/triangle.svg"),
                Container(width: 12),
                Flexible(child: text12And400(item.deliveryPointAddress!)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              openOrderDetails(model, item);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 7, 20, 8),
              decoration: BoxDecoration(
                color: deliveryItemResources.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text14And500WithColorC(
                    deliveryItemResources.text,
                    deliveryItemResources.textColor,
                  ),
                  SvgPicture.asset(
                    "assets/icons/arrow_right.svg",
                    color: deliveryItemResources.textColor,
                    matchTextDirection: isRtlLanguage(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget importantItem(DriverHomeModel model, OrderItem item) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: getAppGradient(),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  text12And400AndColor(
                      item.orderDate!.getFormattedDateTime(), "FFFFFF"),
                  text12And400AndColor(
                      OrderTimeResources.orderTimeToString(item.orderTime),
                      "FFFFFF"),
                ],
              ),
              Column(
                children: [
                  text12And400AndColor("Trip ID:".localize(context), "FFFFFF"),
                  text14And400WithColor(item.id!, Colors.white),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1, color: getColorFromHex("FFFFFF")),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: text12And400AndColor(
                    FlutterI18n.translate(context, "SAR") +
                        " ${item.orderPrice}",
                    "FFFFFF"),
              ),
            ],
          ),
          Container(height: 10),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: (item.companyImageUrl != null
                        ? NetworkImage(item.companyImageUrl!)
                        : AssetImage("assets/images/no_logo.png"))
                    as ImageProvider<Object>?,
                backgroundColor: Colors.white,
                radius: 24,
              ),
              Container(width: 10),
              Flexible(
                  child: text14And500WithColor(item.companyName!, "FFFFFF")),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/ellipse.svg",
                  color: Colors.white,
                ),
                Container(width: 12),
                Flexible(
                  child: text12And400AndColor(item.pickUpAddress!, "FFFFFF"),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/triangle.svg",
                  color: Colors.white,
                ),
                Container(width: 12),
                Flexible(
                  child: text12And400AndColor(
                      item.deliveryPointAddress!, "FFFFFF"),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return cupertinoCancelingDialog(context);
                      },
                    );
                  },
                  child: text14And500WithColor(
                    FlutterI18n.translate(context, "Cancel"),
                    "FFFFFF",
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Container(width: 19),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    openOrderDetails(model, item);
                  },
                  child: text14And500WithColor(
                    FlutterI18n.translate(context, "Details"),
                    "FC8001",
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<BottomScreenItem> getFilterItems(
    BuildContext context,
    OrderFilter activeFilter,
  ) =>
      [
        BottomScreenItem(
          OrderFilter.all,
          OrderFilter.all == activeFilter,
        ),
        BottomScreenItem(
          OrderFilter.readyForDelivery,
          OrderFilter.readyForDelivery == activeFilter,
        ),
        BottomScreenItem(
          OrderFilter.inDelivery,
          OrderFilter.inDelivery == activeFilter,
        ),
      ];

  List<Widget> items(BuildContext context, List<BottomScreenItem> listItems) {
    List<Widget> list = [];
    listItems.forEach((element) {
      list.add(itemMenu(context, element));
    });
    return list;
  }

  Widget itemMenu(BuildContext context, BottomScreenItem item) {
    var model = Provider.of<DriverHomeModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        model.filter = item.filter;
        model.loadOrders("ItemMenu");
        bottomAnimScreen!.closeScreen();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: item.isChecked ? _itemDecorator() : _emptyDecorator(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                OrderFilterResources.orderFilterText(item.filter)
                    .localize(context),
                style: TextStyle(fontSize: 16, color: Colors.white)),
            Visibility(
              visible: item.isChecked,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: SvgPicture.asset("assets/icons/ic_check.svg",
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  openOrderDetails(DriverHomeModel model, OrderItem item) {
    Navigator.pushNamed(
      context,
      Routes.DRIVER_DELIVERY_DETAILS,
      arguments: {
        "item": item,
      },
    ).then((value) {
      if (value == true) {
        model.loadOrders("OpenOrderDetails");
      }
    });
  }

  Decoration _itemDecorator() {
    return BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    );
  }

  // crutch for not working different GestureDetector
  Decoration _emptyDecorator() {
    return BoxDecoration(color: Colors.transparent);
  }

  static const HEADER_TOP_PADDING = 10.0;
  static const USER_PROFILE_COVER_HEIGHT = 48.0;
  static const LIST_TOP_PADDING =
      HEADER_TOP_PADDING + USER_PROFILE_COVER_HEIGHT + 18;
}

class BottomScreenItem {
  OrderFilter filter;
  bool isChecked;

  BottomScreenItem(this.filter, this.isChecked);
}
