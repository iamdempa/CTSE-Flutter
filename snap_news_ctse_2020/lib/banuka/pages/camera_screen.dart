// ====================================================================================
// IT17157124 - This screen provides the facility to take a photo using the camera
// reference: https://www.youtube.com/watch?v=_nS00ZKnINQ&t=193s
// ====================================================================================

// import the packages necessary 
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snap_news_ctse_2020/banuka/pages/add_news.dart';
import 'package:snap_news_ctse_2020/banuka/model/news_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


// camera class 
class CameraScreen extends StatefulWidget {

  // global variables within this class
  News news;
  String didRetake;


  // initialize the variable 
  CameraScreen({Key key, this.news, this.didRetake}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  // controllers to perform events of different widgets 
  CameraController controller;
  List cameras;
  int selectedCameraIndex;
  String imgPath;

  @override
  void initState() {
    super.initState();

    // get the available cameras of the device 
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      // initialize the cameras with controller to swap
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }


  // initialize the camera controller 
  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    // show the scaffold 
    return Scaffold(
      appBar: AppBar(
          backgroundColor: (widget.news != null) ? Colors.orange : Colors.green,
          centerTitle: true,
          // title: Text((widget.news != null) ? "Retake the Photo" : "Take a photo"),
          title: Text((widget.didRetake != null)
              ? (widget.didRetake == "yes")
                  ? "Updae the current photo"
                  : "Retake the Photo"
              : "Take a photo")),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreviewWidget(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  color: (widget.news != null) ? Colors.orange : Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _cameraToggleRowWidget(),
                      _cameraControlWidget(context),
                      Spacer()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Display Camera preview screen
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _cameraControlWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.camera_enhance,
                color: (widget.news != null) ? Colors.orange : Colors.green,
              ),
              backgroundColor: Colors.white,
              onPressed: () {

                // call the capure camera screen
                _onCapturePressed(context);
              },
            )
          ],
        ),
      ),
    );
  }

  // get the name of the camera and show on the screen (front, rear)
  _getName(CameraLensDirection lensDirection) {
    String name = lensDirection
        .toString()
        .substring(lensDirection.toString().indexOf('.') + 1);
    if (name.contains("back")) {
      return "Back";
    } else if (name.contains("front")) {
      return "Front";
    } else {
      return name.toUpperCase();
    }
  }

  // Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
          onPressed: _onSwitchCamera,
          icon: Icon(
            _getCameraLensIcon(lensDirection),
            color: Colors.white,
            size: 24,
          ),
          label: Text(
            _getName(lensDirection),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }


  // get the lens icon of the camera 
  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }


  // show if any errors found a nice exception 
  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }


  // the things to do when camera button is pressed
  void _onCapturePressed(context) async {
    try {
      final path =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      await controller.takePicture(path);
      News news;

      if (widget.didRetake != null) {
        if (widget.didRetake == "yes") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddNews(
                      imgPath: path,
                      news: widget.news,
                      didRetake: "yes",
                    )),
          );
        } else if (widget.didRetake == "no") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNews(imgPath: path)),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddNews(imgPath: path)),
        );
      }
    } catch (e) {
      _showCameraException(e);
    }
  }

  // switch the cameras and what should be done after switching is implemented here 
  void _onSwitchCamera() {

    // get the index of the currently selected camera 
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;

    // get the camera description    
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }
}
