import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

import 'camera_model.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  List<CameraDescription>? _cameras;
  CameraController? _controller;
  CameraDescription? _activeCamera;

  @override
  void initState() {
    super.initState();
    _getAvailableCameras().then((value) {
      if (_cameras!.isNotEmpty) {
        _setCameraController(_cameras![0]);
      }
    });
  }

  Future<void> _getAvailableCameras() async {
    try {
      final cameras = await availableCameras();
      setState(() {
        _cameras = cameras;
      });
    } catch (e) {
      print("_getAvailableCameras $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _cameraView() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return _activeCamera == null
          ? Placeholder(color: Colors.transparent)
          : Container();
    }
    return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: CameraPreview(_controller!));
  }

  IconAndText _getLensIcon(CameraLensDirection lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return IconAndText(Icons.camera_rear, "Back camera".localize(context));
        break;
      case CameraLensDirection.front:
        return IconAndText(
            Icons.camera_front, "Front camera".localize(context));
        break;
      case CameraLensDirection.external:
        return IconAndText(
            Icons.linked_camera, "Outside camera".localize(context));
        break;
    }
    return IconAndText(
        Icons.device_unknown, "Unknown camera".localize(context));
  }

  Widget _lensControl(CameraDescription cameraDescription) {
    IconAndText iconAndText = _getLensIcon(cameraDescription.lensDirection);
    return IconButton(
      icon: _backgroundButton(Icon(iconAndText.iconData)),
      tooltip: iconAndText.text,
      color: Colors.white,
      onPressed: () {
        setState(() {
          _setCameraController(cameraDescription);
        });
      },
    );
  }

  void _setCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);
    _controller!.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await _controller!.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraListWidget() {
    final List<Widget> cameras = <Widget>[];
    if (_cameras == null || _cameras!.isEmpty) {
      return Text("Camera not found".localize(context));
    } else {
      for (CameraDescription cameraDescription in _cameras!) {
        cameras.add(_lensControl(cameraDescription));
      }
    }

    return Column(children: cameras);
  }

  Widget _managementTools() {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Container(alignment: Alignment.bottomRight, child: _cameraListWidget()),
      Consumer<CameraModel>(builder: (context, data, child) {
        return IconButton(
          icon: _backgroundButton(Icon(Icons.camera)),
          tooltip: "Capture photo".localize(context),
          iconSize: 56,
          color: Colors.white,
          onPressed: () => data.savePhoto(_controller!).then((value) {
            if (value == "Captured") {
              Navigator.pop(context, data.photo);
            } else {
              showToast(value!);
            }
          }),
        );
      }),
    ]);
  }

  Widget _backgroundButton(Widget w) {
    return Container(
      child: w,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: <Widget>[_cameraView(), _managementTools()],
      ),
    );
  }
}

class IconAndText {
  IconData iconData;
  String text;

  IconAndText(this.iconData, this.text);
}
