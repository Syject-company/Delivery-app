import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/customer/type_track_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class TypeTrackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TypeTrackModel(
        Provider.of(context),
        Provider.of(context),
        Provider.of(context),
      ),
      builder: (context, _) {
        var model = Provider.of<TypeTrackModel>(context, listen: false);

        model.resultStatusController.stream.listen((event) {
          if (model.isProgress) {
            if (event.isSuccessful) {
              Navigator.pushNamed(context, Routes.DELIVERY_STATUS);
            } else {
              showToast(event.message!);
            }
          }
        });
        return Directionality(
          textDirection: getTextDirection(context),
          child: Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 38, 16, 16),
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 28, 16, 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/images/type_track_cover.png",
                        height: 118,
                      ),
                      const SizedBox(height: 34),
                      text18w600("Type your track ID".localize(context)),
                      Padding(
                          padding: EdgeInsets.fromLTRB(36, 10, 36, 0),
                          child: text16w400(
                            "By adding your track ID you can track or approve your Trip"
                                .localize(context),
                          )),
                      baseTextField(
                        model.trackEdCon,
                        44,
                        0,
                        "Type your track ID".localize(context),
                      ),
                      showProgressOrWidget(
                          buttonSolid(
                            context,
                            30,
                            "Track",
                            () {
                              model.login();
                            },
                          ),
                          model.isShowProgressController.stream),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
