import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/constants/delivery_status.dart';
import 'package:twsl_flutter/src/model/constants/order_time.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/services/tracker_position_model.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/custom/bottom_anim_screen.dart';
import 'package:twsl_flutter/src/ui/custom/gradient_text.dart';
import 'package:twsl_flutter/src/ui/custom/verification_code_widget.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

import 'driver_delivery_details_model.dart';

class DriverDeliveryDetailsScreen extends StatefulWidget {
  @override
  _DriverDeliveryDetailsScreen createState() => _DriverDeliveryDetailsScreen();
}

class _DriverDeliveryDetailsScreen extends State<DriverDeliveryDetailsScreen>
    with SingleTickerProviderStateMixin {
  BottomAnimScreen? bottomAnimScreen;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DriverItemDetailsModel(Provider.of(context)),
      builder: (context, _) {
        var model = Provider.of<DriverItemDetailsModel>(context);
        final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
        model.deliveryItem = arguments["item"];
        model.resultStatusController.stream.listen((event) {
          if (model.isProgress) {
            if (event.isSuccessful) {
              setState(() {});
              if (model.deliveryItem!.orderStatus == DeliveryStatus.completed) {
                Provider.of<TrackerPositionModel>(
                  context,
                  listen: false,
                ).stopTracking();
                showDialog(
                  context: context,
                  builder: (context) => doneDialog(
                    context,
                    () {
                      Navigator.pop(context);
                    },
                  ),
                ).then((value) => Navigator.pop(context, true));
              } else if (model.deliveryItem!.orderStatus ==
                  DeliveryStatus.inDelivery) {
                Provider.of<TrackerPositionModel>(
                  context,
                  listen: false,
                ).startTracking();
              }
            } else {
              showToast(event.message!);
            }
            model.isProgress = false;
          }
        });
        if (bottomAnimScreen == null) {
          bottomAnimScreen = BottomAnimScreen(
            child: slideMenu(model),
          );
        }

        var orderStatus = model.deliveryItem!.orderStatus;
        return WillPopScope(
          onWillPop: bottomAnimScreen!.onWillPop,
          child: Directionality(
            textDirection: getTextDirection(context),
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Details".localize(context),
                  style: TextStyle(color: "454F63".getColor()),
                ),
                backgroundColor:
                    orderStatus == null || orderStatus == DeliveryStatus.created
                        ? "F3F3F3".getColor()
                        : Colors.white,
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Visibility(
                          visible: orderStatus != null &&
                              orderStatus != DeliveryStatus.created,
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: HEADER_PADDING_BOTTOM),
                            child: GestureDetector(
                              child: _header(
                                context,
                                model,
                              ),
                              onTap: () {
                                bottomAnimScreen!.openScreen();
                              },
                            ),
                          ),
                        ),
                        body(context, model.deliveryItem!),
                        Visibility(
                          visible: orderStatus == null ||
                              orderStatus == DeliveryStatus.created ||
                              orderStatus ==
                                  DeliveryStatus.waitingConfirmationUser ||
                              orderStatus == DeliveryStatus.readyForDelivery,
                          child: bottomButtons(
                            context,
                            orderStatus != DeliveryStatus.created,
                            orderStatus == DeliveryStatus.created,
                            model,
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomAnimScreen!,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, DriverItemDetailsModel model) {
    DeliveryStatusData deliveryRes = DeliveryStatusResources.getValue(
      model.deliveryItem!.orderStatus,
      context,
    );

    DeliveryStatusData readyStatus = DeliveryStatusResources.getValue(
      DeliveryStatus.readyForDelivery,
      context,
    );
    DeliveryStatusData inDelivery = DeliveryStatusResources.getValue(
      DeliveryStatus.inDelivery,
      context,
    );
    DeliveryStatusData delivered = DeliveryStatusResources.getValue(
      DeliveryStatus.delivered,
      context,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(38, 20, 38, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statusButton(
                  readyStatus.gradientBackgroundColors,
                  readyStatus.iconSvgAssetPath,
                  isActiveButtonStatus(
                    DeliveryStatus.waitingConfirmationUser,
                    model.deliveryItem!.orderStatus,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    "assets/icons/arrow_right_status.svg",
                    color: isActiveButtonStatus(DeliveryStatus.readyForDelivery,
                            model.deliveryItem!.orderStatus)
                        ? "FDBE01".getColor()
                        : "C8C8C8".getColor(),
                    matchTextDirection: isRtlLanguage(context),
                  ),
                ),
                _statusButton(
                  inDelivery.gradientBackgroundColors,
                  inDelivery.iconSvgAssetPath,
                  isActiveButtonStatus(
                    DeliveryStatus.inDelivery,
                    model.deliveryItem!.orderStatus,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    "assets/icons/arrow_right_status.svg",
                    color: isActiveButtonStatus(DeliveryStatus.delivered,
                            model.deliveryItem!.orderStatus)
                        ? "06ABDF".getColor()
                        : "C8C8C8".getColor(),
                    matchTextDirection: isRtlLanguage(context),
                  ),
                ),
                _statusButton(
                  delivered.gradientBackgroundColors,
                  delivered.iconSvgAssetPath,
                  isActiveButtonStatus(
                    DeliveryStatus.completed,
                    model.deliveryItem!.orderStatus,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          showProgressOrWidget(
            Container(
              height: READY_DELIVERY_BUTTON_HEIGHT,
              decoration: BoxDecoration(
                color: deliveryRes.backgroundColor,
                borderRadius:
                    BorderRadius.circular(READY_DELIVERY_BUTTON_HEIGHT / 2),
              ),
              child: InkWell(
                onTap: () {
                  switch (model.deliveryItem!.orderStatus) {
                    case DeliveryStatus.expired:
                      break;
                    case DeliveryStatus.created:
                      break;
                    case DeliveryStatus.waitingConfirmationUser:
                      break;
                    case DeliveryStatus.readyForDelivery:
                      model.startDelivering(model.deliveryItem!.id);
                      break;
                    case DeliveryStatus.inDelivery:
                      model.deliveredOrder(model.deliveryItem!.id);
                      break;
                    case DeliveryStatus.delivered:
                      showDialog(
                        context: context,
                        builder: (_) => BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: VerificationCodeWidget(
                              titleText:
                                  "Please Ask for the, Trip verification code to the customer "
                                      .localize(context),
                              buttonText: "Submit".localize(context),
                              isShowProgressStream: model.isShowProgress.stream,
                              submitCallback: (code) {
                                model.confirmDeliveredOrder(
                                  model.deliveryItem!.id,
                                  code,
                                );
                              },
                              resetCodeCallback: () {
                                model.resendConfirmCode(model.deliveryItem!.id);
                              },
                            ),
                          ),
                        ),
                      );
                      break;
                    case DeliveryStatus.completed:
                      break;
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: model.deliveryItem!.orderStatus !=
                                DeliveryStatus.waitingConfirmationUser
                            ? 48
                            : 0),
                    Center(
                      child: Text(
                        deliveryRes.text.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: deliveryRes.textColor,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: model.deliveryItem!.orderStatus !=
                          DeliveryStatus.waitingConfirmationUser,
                      child: _statusButton(
                        deliveryRes.gradientBackgroundColors,
                        delivered.iconSvgAssetPath,
                        true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            model.isShowProgress.stream,
            progressTopPadding: 16,
            progressBottomPadding: 16,
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: model.deliveryItem!.orderStatus ==
                DeliveryStatus.waitingConfirmationUser,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: GradientText(
              "Please wait until the customer approve for delivery"
                  .localize(context),
              gradient: LinearGradient(
                colors: [
                  "1F959DAD".getColor(),
                  "9DA4B2".getColor(),
                  "1FC0C2C7".getColor()
                ],
              ),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  bool isActiveButtonStatus(
    DeliveryStatus statusButton,
    DeliveryStatus status,
  ) {
    return statusButton.index <= status.index;
  }

  Widget _statusButton(List<Color> colors, String icon, bool isActive) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [
          isActive ? colors[0] : "F4F4F4".getColor(),
          isActive ? colors[1] : "C8C8C8".getColor(),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Center(child: SvgPicture.asset(icon)),
    );
  }

  Widget body(BuildContext context, OrderItem item) {
    var model = Provider.of<DriverItemDetailsModel>(context, listen: false);
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: text14And400(item.pickUpAddress!),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        model.deliveryItem!.companyPhoneNumber!.callingOnPhone();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: "DEF6EE".getColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: SvgPicture.asset("assets/icons/phone.svg"),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.NAVIGATE,
                            arguments: {
                              "end_position_lat":
                                  model.deliveryItem!.pickUpPointLatitude,
                              "end_position_lon":
                                  model.deliveryItem!.pickUpPointLongitude,
                            });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: "E4ECFF".getColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: SvgPicture.asset("assets/icons/navigation.svg"),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
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
                "${"Name".localize(context)} ${item.customerName}",
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: text14And400(item.deliveryPointAddress!),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        model.deliveryItem!.customerPhoneNumber!.callingOnPhone();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: "DEF6EE".getColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: SvgPicture.asset("assets/icons/phone.svg"),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: "F9E4EB".getColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.CHAT,
                          arguments: {'orderId': model.deliveryItem!.id},
                        );
                      },
                      child: SvgPicture.asset("assets/icons/message.svg"),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: "E4ECFF".getColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.NAVIGATE,
                            arguments: {
                              "end_position_lat":
                                  model.deliveryItem!.deliveryPointLatitude,
                              "end_position_lon":
                                  model.deliveryItem!.deliveryPointLongitude,
                            });
                      },
                      child: SvgPicture.asset("assets/icons/navigation.svg"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons(
    BuildContext context,
    bool isShowCancel,
    bool isShowAccepted,
    DriverItemDetailsModel model,
  ) {
    return Container(
      padding: EdgeInsets.all(30),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: isShowCancel,
            child: showProgressOrWidget(
              SizedBox(
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: "BD2755".getColor(),
                    backgroundColor: "F9E4EB".getColor(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    model.cancelDelivery();
                  },
                  child: Text("Cancel delivery".localize(context)),
                ),
              ),
              model.isShowProgress.stream,
              progressTopPadding: 16,
              progressBottomPadding: 16,
            ),
          ),
          SizedBox(height: isShowCancel && isShowAccepted ? 16 : 0),
          Visibility(
            visible: isShowAccepted,
            child: showProgressOrWidget(
              SizedBox(
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: "BD2755".getColor(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    model.takeOrder(model.deliveryItem!.id);
                  },
                  child: Text("Accept".localize(context)),
                ),
              ),
              model.isShowProgress.stream,
              progressTopPadding: 16,
              progressBottomPadding: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget slideMenu(DriverItemDetailsModel model) {
    var status = model.deliveryItem!.orderStatus;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 40,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: (CIRCLE_DOT_WIDTH / 2) - 1,
              right: (CIRCLE_DOT_WIDTH / 2),
            ),
            child: Flex(
              children: List.generate(59, (i) {
                // ignore: todo
                //TODO need generate height from position dots
                if (i % 2 == 0) {
                  return const SizedBox(width: 1, height: 4);
                } else {
                  return SizedBox(
                    width: 1,
                    height: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: "B4BBCA".getColor()),
                    ),
                  );
                }
              }),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              direction: Axis.vertical,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  circleInCircle(
                    isActiveButtonStatus(
                            DeliveryStatus.waitingConfirmationUser, status)
                        ? ["FDBE01".getColor(), "FC7F01".getColor()]
                        : ["B4BBCA".getColor(), "B4BBCA".getColor()],
                  ),
                  const SizedBox(width: PADDING_FROM_DOT),
                  text14And600WithColor(
                    "“Ready for delivery” Section".localize(context),
                    isActiveButtonStatus(
                            DeliveryStatus.waitingConfirmationUser, status)
                        ? "454F63".getColor()
                        : "B4BBCA".getColor(),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: PADDING_WITHOUT_DOT,
                    top: 4,
                    right: PADDING_WITHOUT_DOT),
                child: text12And400AndColor(
                  "Waiting for customer response".localize(context),
                  isActiveButtonStatus(
                          DeliveryStatus.waitingConfirmationUser, status)
                      ? "454F63"
                      : "B4BBCA",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: PADDING_WITHOUT_DOT,
                  top: 10,
                  bottom: 40,
                  right: PADDING_WITHOUT_DOT,
                ),
                child: text12And400AndColor(
                    "Preparation for delivery".localize(context),
                    isActiveButtonStatus(
                            DeliveryStatus.readyForDelivery, status)
                        ? "454F63"
                        : "B4BBCA"),
              ),
              Row(
                children: [
                  circleInCircle(
                    isActiveButtonStatus(DeliveryStatus.inDelivery, status)
                        ? ["50E5CB".getColor(), "06ABDF".getColor()]
                        : ["B4BBCA".getColor(), "B4BBCA".getColor()],
                  ),
                  const SizedBox(width: PADDING_FROM_DOT),
                  text14And600WithColor(
                    "“In Delivery” Section".localize(context),
                    isActiveButtonStatus(DeliveryStatus.inDelivery, status)
                        ? "454F63".getColor()
                        : "B4BBCA".getColor(),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: PADDING_WITHOUT_DOT,
                  top: 4,
                  right: PADDING_WITHOUT_DOT,
                ),
                child: text12And400AndColor(
                  "On this section you have to going to the customer location"
                      .localize(context),
                  isActiveButtonStatus(DeliveryStatus.inDelivery, status)
                      ? "454F63"
                      : "B4BBCA",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: PADDING_WITHOUT_DOT,
                  top: 10,
                  bottom: 40,
                  right: PADDING_WITHOUT_DOT,
                ),
                child: text12And400AndColor(
                  "Remember that when you’r in “In Delivery” section customer will be able to track you by map view"
                      .localize(context),
                  isActiveButtonStatus(DeliveryStatus.inDelivery, status)
                      ? "454F63"
                      : "B4BBCA",
                ),
              ),
              Row(
                children: [
                  circleInCircle(
                    isActiveButtonStatus(DeliveryStatus.delivered, status)
                        ? ["8EE078".getColor(), "38B081".getColor()]
                        : ["B4BBCA".getColor(), "B4BBCA".getColor()],
                  ),
                  const SizedBox(width: PADDING_FROM_DOT),
                  text14And600WithColor(
                      "“Delivered” Section".localize(context),
                      isActiveButtonStatus(DeliveryStatus.delivered, status)
                          ? "454F63".getColor()
                          : "B4BBCA".getColor()),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: PADDING_WITHOUT_DOT,
                  top: 4,
                  right: PADDING_WITHOUT_DOT,
                ),
                child: text12And400AndColor(
                  "Give the product to customer".localize(context),
                  isActiveButtonStatus(DeliveryStatus.delivered, status)
                      ? "454F63"
                      : "B4BBCA",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: PADDING_WITHOUT_DOT,
                  top: 10,
                  right: PADDING_WITHOUT_DOT,
                ),
                child: text12And400AndColor(
                  "Receive OTP from customer".localize(context),
                  isActiveButtonStatus(DeliveryStatus.delivered, status)
                      ? "454F63"
                      : "B4BBCA",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget circleInCircle(List<Color> colors) {
    return SizedBox(
      height: CIRCLE_DOT_WIDTH,
      width: CIRCLE_DOT_WIDTH,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: SizedBox(
            height: 6,
            width: 6,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  static const CIRCLE_DOT_WIDTH = 16.0;
  static const PADDING_FROM_DOT = 20.0;
  static const PADDING_WITHOUT_DOT = CIRCLE_DOT_WIDTH + PADDING_FROM_DOT;
  static const READY_DELIVERY_BUTTON_HEIGHT = 48.0;
  static const BODY_PADDING_TOP = 8.0;
  static const HEADER_PADDING_BOTTOM = 20 - BODY_PADDING_TOP;
  static const POINT_HEIGHT = 30.0;
}
