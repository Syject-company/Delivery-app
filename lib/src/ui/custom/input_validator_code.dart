import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputValidatorCode extends StatefulWidget {
  final _firstEdCon = TextEditingController();
  final _secondEdCon = TextEditingController();
  final _thirdEdCon = TextEditingController();
  final _fourthEdCon = TextEditingController();

  String getCode() {
    return _firstEdCon.text +
        _secondEdCon.text +
        _thirdEdCon.text +
        _fourthEdCon.text;
  }

  @override
  _InputValidatorCode createState() => _InputValidatorCode();
}

class _InputValidatorCode extends State<InputValidatorCode> {
  FocusNode? _focusNode2;
  FocusNode? _focusNode3;
  FocusNode? _focusNode4;

  @override
  void initState() {
    super.initState();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        onceNumber(true, null, widget._firstEdCon, (str) {
          if (str.length == 1) {
            FocusScope.of(context).requestFocus(_focusNode2);
          }
        }),
        onceNumber(false, _focusNode2, widget._secondEdCon, (str) {
          if (str.length == 1) {
            FocusScope.of(context).requestFocus(_focusNode3);
          }
        }),
        onceNumber(false, _focusNode3, widget._thirdEdCon, (str) {
          if (str.length == 1) {
            FocusScope.of(context).requestFocus(_focusNode4);
          }
        }),
        onceNumber(false, _focusNode4, widget._fourthEdCon, (str) {
          if (str.length == 1) {}
        }),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode2!.dispose();
    _focusNode3!.dispose();
    _focusNode4!.dispose();
    super.dispose();
  }

  Widget onceNumber(bool autoFocus, FocusNode? node,
      TextEditingController controller, Function fun) {
    return Flexible(
      child: Container(
        width: 48,
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 18),
          maxLength: 1,
          autofocus: autoFocus,
          focusNode: node,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            counter: Container(),
          ),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          onChanged: fun as void Function(String)?,
        ),
      ),
    );
  }
}
