import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ShowCamera extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ShowCamera(this.cameras);

  @override
  _ShowCameraState createState() => _ShowCameraState();
}

class _ShowCameraState extends State<ShowCamera> {
  CameraController camController;

  @override
  void initState() {
    super.initState();
    camController = CameraController(widget.cameras[0], ResolutionPreset.high);
    camController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    if (!camController.value.isInitialized) {
      return Container(
        child: Text('No Camera Could be Initialized.'),
      );
    }

    int turns = 1;

    return Container(
      width: 300,
      height: 220,
      child: RotatedBox(
        quarterTurns: turns,
        child: AspectRatio(
          aspectRatio: camController.value.aspectRatio,
          child: CameraPreview(camController),
        ),
      ),
    );
  }

  @override
  void dispose() {
    camController?.dispose();
    super.dispose();
  }
}
