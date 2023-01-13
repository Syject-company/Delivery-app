import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/constants/delivery_status.dart';
import 'package:twsl_flutter/src/model/constants/order_time.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/customer/delivery_status/delivery_status_model.dart';
import 'package:twsl_flutter/src/ui/customer/delivery_status/navigate_markers.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class DeliveryStatusScreen extends StatefulWidget {
  @override
  _DeliveryStatusScreen createState() => _DeliveryStatusScreen();
}

class _DeliveryStatusScreen extends State<DeliveryStatusScreen> {
  PageController _pageController = PageController();
  late NavigateMarkers _navigateMarkers;
  static const double _distanceToEarthInMeters = 8000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeliveryStatusModel(
        Provider.of(context),
        Provider.of(context),
      ),
      builder: (context, _) {
        var model = Provider.of<DeliveryStatusModel>(context, listen: false);
        model.resultStatusController.stream.listen((event) {
          if (model.isProgress) {
            if (event.isSuccessful) {
              if (model.isRescheduling) {
                model.endRescheduling();
              }
            } else {
              showToast(event.message!);
            }
            model.isProgress = false;
          }
        });
        return WillPopScope(
          onWillPop: () => onWillPopScope(
            model,
          ),
          child: Directionality(
            textDirection: getTextDirection(context),
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Details".localize(context),
                  style: TextStyle(color: "454F63".getColor()),
                ),
                backgroundColor: Colors.white,
                // actions: [
                //   IconButton(
                //     icon: SvgPicture.asset("assets/icons/question.svg"),
                //     onPressed: () {},
                //   ),
                // ],
              ),
              body: Consumer<DeliveryStatusModel>(
                builder: (context, data, _) {
                  return Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      data.isRescheduling
                          ? rescheduleProcess(context, data)
                          : data.deliveryItem != null
                              ? _body(context, data)
                              : Center(child: CircularProgressIndicator()),
                      _header(context, data),
                      Visibility(
                        visible: data.deliveryItem?.orderStatus ==
                                DeliveryStatus.waitingConfirmationUser ||
                            data.deliveryItem?.orderStatus ==
                                DeliveryStatus.readyForDelivery ||
                            data.deliveryItem?.orderStatus ==
                                DeliveryStatus.inDelivery,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: openChat(context, "driver"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget openChat(BuildContext context, String driverName) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.CHAT,
              arguments: {
                'orderId':
                    Provider.of<DeliveryStatusModel>(context, listen: false)
                        .deliveryItem!
                        .id
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(27, 18, 29, 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text16w800("Open a chat with driver".localize(context)),
                SvgPicture.asset("assets/icons/message.svg"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPopScope(DeliveryStatusModel model) async {
    if (model.isRescheduling) {
      if (_pageController.page! > 0) {
        _pageController.previousPage(
          duration: Duration(milliseconds: 200),
          curve: Curves.linear,
        );
        return false;
      } else if (_pageController.page == 0) {
        model.endRescheduling();
        return false;
      }
    }
    return true;
  }

  Widget _header(BuildContext context, DeliveryStatusModel model) {
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
      alignment: Alignment.topCenter,
      height: HEADER_HEIGHT,
      padding: EdgeInsets.fromLTRB(38, 24, 38, 40),
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
                    model.deliveryItem?.orderStatus,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    "assets/icons/arrow_right_status.svg",
                    color: isActiveButtonStatus(DeliveryStatus.readyForDelivery,
                            model.deliveryItem?.orderStatus)
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
                    model.deliveryItem?.orderStatus,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    "assets/icons/arrow_right_status.svg",
                    color: isActiveButtonStatus(DeliveryStatus.delivered,
                            model.deliveryItem?.orderStatus)
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
                    model.deliveryItem?.orderStatus,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isActiveButtonStatus(
    DeliveryStatus statusButton,
    DeliveryStatus? status,
  ) {
    var statusIndex = status?.index ?? 0;
    return statusButton.index <= statusIndex;
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

  Widget _body(BuildContext context, DeliveryStatusModel model) {
    switch (model.deliveryItem?.orderStatus) {
      case DeliveryStatus.expired:
        return deliveryExpired(context);
      case DeliveryStatus.created:
        return waitingDriverConfirm();
      case DeliveryStatus.waitingConfirmationUser:
        return confirmDialog(context, model);
      case DeliveryStatus.readyForDelivery:
        return Center(child: pleaseWait());
 /*     case DeliveryStatus.inDelivery:
        model.getDriverPosition();
        return inDeliveryWidget(context, model);*/
      case DeliveryStatus.delivered:
        return deliveredWidget(context);
      case DeliveryStatus.completed:
        return deliveryWasGet();
      default:
        return const SizedBox();
    }
  }

  Widget confirmDialog(BuildContext context, DeliveryStatusModel model) {
    String orderTime;
    if (model.deliveryItem!.orderTime == OrderTime.none) {
      orderTime = OrderTimeResources.orderTimeToString(OrderTime.morning);
    } else {
      orderTime =
          OrderTimeResources.orderTimeToString(model.deliveryItem!.orderTime);
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),
                text18w600("Confirm your delivery".localize(context)),
                const SizedBox(height: 20),
                Text(
                  "If you didn’t confirm your delivery it will expire on"
                      .localize(context),
                  textAlign: TextAlign.center,
                ),
                text14And400WithColor(
                  "${model.deliveryItem!.orderDate!.getFormattedDate()}, ${orderTime.localize(context)}",
                  "FF4242".getColor(),
                ),
                const SizedBox(height: 47),
                Container(height: 1, color: "8F959DAD".getColor()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 1),
                    SizedBox(
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          model.startRescheduling();
                        },
                        child: text14And400("Cancel".localize(context)),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        width: 1,
                        height: 40,
                        color: "8F959DAD".getColor(),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          model.confirmDateDelivery();
                        },
                        child: text14And400WithColor(
                          "Confirm".localize(context),
                          "37D09D".getColor(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 1),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pleaseWait() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: 340,
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(16, 40, 16, 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image.asset("assets/images/empty_home.png"),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
              child: Text(
                "Please wait!".localize(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: "454F63".getColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              "Your product is about to be picked up and being ready to on its way"
                  .localize(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: "454F63".getColor(),
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

/*  Widget inDeliveryWidget(BuildContext context, DeliveryStatusModel model) {
    askPermissionOnLocation();

    _navigateMarkers = NavigateMarkers(() {
      initPositionMarkers(model);
    });

    model.driverPosController.stream.listen((event) {
      if (_navigateMarkers.hereMapController != null) {
        _navigateMarkers.addDriverMarker(event!, 1);
        _navigateMarkers.hereMapController?.camera.lookAtPointWithDistance(
          event,
          _distanceToEarthInMeters,
        );
      }
    });
    return HereMap(onMapCreated: _onMapCreated);
  }*/

/*  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError? error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      } else {
        _navigateMarkers.setHereMapController(hereMapController);
      }
    });
  }*/

  void initPositionMarkers(DeliveryStatusModel model) async {
    var myPositionRaw = await Geolocator.getCurrentPosition();
/*    var myPos = GeoCoordinates(myPositionRaw.latitude, myPositionRaw.longitude);*/

   // _navigateMarkers.addCustomerMarker(myPos, 0);
   // _navigateMarkers.hereMapController!.camera.lookAtPointWithDistance(
 /*     myPos,*/
   /*   _distanceToEarthInMeters,
    );*/
  }

  Widget deliveredWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, HEADER_HEIGHT + 20, 16, 69),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 43),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("assets/images/otp.png", height: 90),
              Padding(
                padding: EdgeInsets.only(top: 25, bottom: 30),
                child: text16w400(
                  "Say the OTP code you just received by SMS to the driver"
                      .localize(context),
                ),
              ),
              Divider(height: 1),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 23),
                child: Image.asset("assets/images/enjoy.png", height: 90),
              ),
              text18w600("Enjoy!".localize(context)),
              Padding(
                padding: EdgeInsets.only(top: 4, bottom: 40),
                child:
                    text16w400("Your delivery is complete ".localize(context)),
              ),
              Divider(height: 1),
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 27),
                child:
                    Image.asset("assets/images/any_problems.png", height: 90),
              ),
              Text(
                "Did you have any problem?".localize(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: "454F63".getColor(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: "BD2755".getColor())),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: text14And500("No".localize(context)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 21),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: "BC2954".getColor(),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.ISSUE_FEEDBACK);
                          },
                          child: text14And500WithColorC(
                              "Yes".localize(context), Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deliveryExpired(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Your delivery was expired/cancelled".localize(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: "EB5757".getColor(),
                ),
              ),
              // buttonSolid(
              //   context,
              //   20,
              //   "Re-Order".localize(context),
              //   () {},
              //   paddingBottom: 0,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rescheduleProcess(BuildContext context, DeliveryStatusModel model) {
    var defDate = model.deliveryItem!.orderDate!;
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        warning(() {
          nextPage();
        }),
        Center(
          child: scheduleDateWidget(context, defDate, (value) {
            model.rescheduleDate = value;
            nextPage();
          }),
        ),
        Center(
          child: scheduleTimeWidget(context, (value) {
            model.rescheduleTime = value;
            nextPage();
          }),
        ),
        rescheduleDone(model, () {
          model.reschedule();
          model.confirmDateDelivery();
        }),
      ],
    );
  }

  nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  Widget warning(Function click) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 60, 16, 43),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/warning.png",
                height: 114,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 21, 0, 10),
                child: Text(
                  "Warning!".localize(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: "454F63".getColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                "If you confirm to reschedule your trip, it cannot be modified again"
                    .localize(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: "EB5757".getColor(),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              buttonSolid(
                context,
                40,
                "Continue",
                click,
                paddingBottom: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget waitingDriverConfirm() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 60, 16, 43),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/warning.png",
                height: 114,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 21, 0, 10),
                child: Text(
                  "Please wait".localize(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: "454F63".getColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                "This delivery has not yet been confirmed by the driver."
                    .localize(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              buttonSolid(
                context,
                40,
                "Go back",
                () {
                  Navigator.pop(context);
                },
                paddingBottom: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rescheduleDone(DeliveryStatusModel model, Function click) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 60, 16, 43),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/warning.png",
                height: 114,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 21, 0, 10),
                child: Text(
                  "Is reschedule?".localize(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: "454F63".getColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                "This will change the delivery date and time."
                    .localize(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              showProgressOrWidget(
                buttonSolid(
                  context,
                  40,
                  "Reschedule",
                  click,
                  paddingBottom: 0,
                ),
                model.isShowProgressController.stream,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deliveryWasGet() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 60, 16, 43),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/done.png",
                height: 114,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 21, 0, 10),
                child: Text(
                  "Received!".localize(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: "454F63".getColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                "This package has already been received.".localize(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              buttonSolid(
                context,
                40,
                "Done",
                () => Navigator.pop(context),
                paddingBottom: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget scheduleDateWidget(
    BuildContext context,
    DateTime defDate,
    Function(DateTime) click,
  ) {
    var newDate1 = DateTime(defDate.year, defDate.month, defDate.day + 1);
    var newDate2 = DateTime(defDate.year, defDate.month, defDate.day + 2);
    var newDate3 = DateTime(defDate.year, defDate.month, defDate.day + 3);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              scheduleItem(
                DateFormat('EEEE').format(newDate1),
                newDate1.getFormattedDate(),
                () => click.call(newDate1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1),
              ),
              scheduleItem(
                DateFormat('EEEE').format(newDate2),
                newDate2.getFormattedDate(),
                () => click.call(newDate2),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1),
              ),
              scheduleItem(
                DateFormat('EEEE').format(newDate3),
                newDate3.getFormattedDate(),
                () => click.call(newDate3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget scheduleTimeWidget(BuildContext context, Function(OrderTime) click) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              scheduleItem(
                "Morning".localize(context),
                "5:00 AM — 11:59 AM",
                () => click.call(OrderTime.morning),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1),
              ),
              scheduleItem(
                "Afternoon",
                "12:00 PM — 4:59 PM",
                () => click.call(OrderTime.afternoon),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1),
              ),
              scheduleItem(
                "Evening",
                "5:00 PM — 10:00 PM",
                () => click.call(OrderTime.evening),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget scheduleItem(String text1, String text2, Function fun) {
    return Ink(
      padding: EdgeInsets.all(16),
      child: InkWell(
        onTap: () => fun.call(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              text2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: "B4BBCA".getColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  askPermissionOnLocation() async {
    if (!(await Permission.location.isGranted)) {
      await [Permission.location].request().then((value) {
        if (value.values.first.isGranted) {
          setState(() {});
        }
      });
    }
  }

  static const HEADER_HEIGHT = 112.0;
}
