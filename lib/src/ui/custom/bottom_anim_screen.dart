import 'dart:ui';

import 'package:flutter/material.dart';

class BottomAnimScreen extends StatefulWidget {
  Widget child;
  late AnimationController controller;
  bool _isOpen = false;

  BottomAnimScreen({
    required this.child,
    Key? key,
  }) : super(key: key);

  bool positionScreenIsOpen() => _isOpen;

  openScreen() {
    _isOpen = true;
    controller.forward();
  }

  closeScreen() {
    _isOpen = false;
    controller.reverse();
  }

  Future<bool> onWillPop() async {
    if (_isOpen) {
      closeScreen();
      return false;
    } else {
      return true;
    }
  }

  @override
  _BottomAnimScreen createState() => _BottomAnimScreen();
}

class _BottomAnimScreen extends State<BottomAnimScreen>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    widget.controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(widget.controller)
      ..addListener(() {
        print("Anim listener");
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget._isOpen,
      child: GestureDetector(
        onTap: () {
          print("On tapped. isOpen = ${widget._isOpen}");
          widget.closeScreen();
        },
        onVerticalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            widget.closeScreen();
          } else if (details.primaryVelocity! < 0) {}
        },
        child: Container(
          color: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget._isOpen ? 3 : 0,
              sigmaY: widget._isOpen ? 3 : 0,
            ),
            child: _filterScreen(),
          ),
        ),
      ),
    );
  }

  Widget _filterScreen() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
