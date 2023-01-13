import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/profile/payment_history/payment_day_details/payment_day_details_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class PaymentDayDetailsScreen extends StatefulWidget {
  @override
  _PaymentDayDetailsScreen createState() => _PaymentDayDetailsScreen();
}

class _PaymentDayDetailsScreen extends State<PaymentDayDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<PaymentDayDetailsModel>(context, listen: false);
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
          bottom: toolbarBottom() as PreferredSizeWidget?,
        ),
        body: ListView.builder(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            itemCount: 25,
            itemBuilder: (context, index) {
              return item(context, model, index);
            }),
      ),
    );
  }

  Widget item(BuildContext context, PaymentDayDetailsModel model, index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.DELIVERY_DETAILS);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text12And400("June 14, 09:24am "),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: "BD2755".getColor()),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: text12And400AndColor(
                        "SAR".localize(context) + " 63",
                        "BD2755",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "http://restoranoved.ru/netcat_files/452/861/makdonaldslogo_1.jpg"),
                      backgroundColor: Colors.white,
                      radius: 24,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset("assets/icons/ellipse.svg"),
                            Container(width: 12),
                            text12And400("Rakkah, Al Khobar 31952"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SvgPicture.asset("assets/icons/triangle.svg"),
                            Container(width: 12),
                            text12And400("Al Muntazah, Khamis Mushait 624"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget toolbarBottom() {
    return PreferredSize(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text16w500("6th March, 2020", color: Colors.white),
                text16w500("#GH358F", color: Colors.white),
              ],
            ),
            const SizedBox(height: 34),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text16w400("Total Rides".localize(context),
                    color: Colors.white),
                text16w400("Paid".localize(context), color: Colors.white),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "734",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "SAR 32.64",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(140),
    );
  }
}
