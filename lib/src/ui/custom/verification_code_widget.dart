import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/custom/input_validator_code.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class VerificationCodeWidget extends StatefulWidget {
  final Function(String code) submitCallback;
  final Function() resetCodeCallback;
  final String? titleText;
  final String buttonText;
  final Stream isShowProgressStream;

  VerificationCodeWidget({
    this.titleText,
    required this.buttonText,
    required this.isShowProgressStream,
    required this.submitCallback,
    required this.resetCodeCallback,
  });

  @override
  _VerificationCodeWidget createState() => _VerificationCodeWidget();
}

class _VerificationCodeWidget extends State<VerificationCodeWidget> {
  Timer? _timer;
  static const _START_TIMER_TIME = 60;
  var _tempTimer = 0;

  StreamController<int> timerStream = BehaviorSubject();
  InputValidatorCode inputValidatorCode = InputValidatorCode();

  @override
  Widget build(BuildContext context) {
    startTimer();
    return Container(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: true,
              child: IconButton(
                  alignment: Alignment.topRight,
                  icon: SvgPicture.asset("assets/icons/close.svg"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            text16w500(widget.titleText!),
            const SizedBox(height: 36),
            inputValidatorCode,
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Center(
                child: StreamBuilder(
                    stream: timerStream.stream,
                    builder: (ctx, data) {
                      return _textWithTimerOnNot(
                        context,
                        data.data as int,
                      );
                    }),
              ),
            ),
            showProgressOrWidget(
              buttonSolid(
                context,
                30,
                widget.buttonText,
                () {
                  if (inputValidatorCode.getCode().length == 4) {
                    widget.submitCallback.call(inputValidatorCode.getCode());
                  } else {
                    showToast("Code is not valid".localize(context));
                  }
                },
                horizontalPadding: 0,
              ),
              widget.isShowProgressStream,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textWithTimerOnNot(BuildContext context, int? time) {
    print("Time = $time");
    if (time != 0) {
      return textWithClickableTextAndMutable(
        context,
        "Resend code in",
        (time ?? _START_TIMER_TIME).toString(),
        "Seconds",
        TapGestureRecognizer()
          ..onTap = () {
            showToast("We need to wait a little longer".localize(context));
          },
      );
    } else {
      return textWithClickableText(
        context,
        "Didn’t receive yet?",
        "Send again",
        TapGestureRecognizer()
          ..onTap = () {
            showToast("Reset code".localize(context));
            widget.resetCodeCallback.call();
            resetTimer(); //TODO reset timer after successful request
          },
      );
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _tempTimer = _START_TIMER_TIME;
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_tempTimer < 1) {
        timer.cancel();
      } else {
        _tempTimer = _tempTimer - 1;
      }
      timerStream.sink.add(_tempTimer);
    });
  }

  resetTimer() {
    _timer!.cancel();
    _tempTimer = 0;
  }

  closeTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    timerStream.close();
    closeTimer();
    super.dispose();
  }
}
