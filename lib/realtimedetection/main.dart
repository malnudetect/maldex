// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malnudetect/screens/bottom_nav_screen.dart';

enum Options { none, imagev8, frame, vision }

late List<CameraDescription> cameras;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(
    const MaterialApp(
      home: RealTimeDetectionScreen(),
    ),
  );
}

class RealTimeDetectionScreen extends StatefulWidget {
  static const String routeName = '/real-time-detection-screen';

  const RealTimeDetectionScreen({Key? key}) : super(key: key);

  @override
  State<RealTimeDetectionScreen> createState() =>
      _RealTimeDetectionScreenState();
}

class _RealTimeDetectionScreenState extends State<RealTimeDetectionScreen> {
  late FlutterVision vision;
  Options option = Options.none;
  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
  }

  Widget speeddialbutton() {
    return SpeedDial(
      //margin bottom
      icon: Icons.menu, //icon on Floating action button
      activeIcon: Icons.close, //icon when menu is expanded on button
      backgroundColor:
          const Color.fromARGB(255, 96, 100, 203), //background color of button
      foregroundColor: Colors.white, //font color, icon color in button
      activeBackgroundColor:
          Colors.deepPurpleAccent, //background color when menu is expanded
      activeForegroundColor: Colors.white,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      buttonSize: const Size(56.0, 56.0),
      children: [
        SpeedDialChild(
          //speed dial child
          child: const Icon(Icons.video_call),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          label: 'Start Capturing',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () {
            setState(() {
              option = Options.frame;
            });
          },
        ),
        // SpeedDialChild(
        //   child: const Icon(Icons.camera),
        //   backgroundColor: Colors.blue,
        //   foregroundColor: Colors.white,
        //   label: 'Detect on Image',
        //   labelStyle: const TextStyle(fontSize: 18.0),
        //   onTap: () {
        //     setState(() {
        //       option = Options.imagev8;
        //     });
        //   },
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: task(option),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 100, 203),
        title: Text(
          "MalDex",
          style: GoogleFonts.bubblegumSans(
            fontSize: 34,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: SpeedDial(
        //margin bottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Colors.black12, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor: const Color.fromARGB(
            255, 96, 100, 203), //background color when menu is expanded
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        buttonSize: const Size(56.0, 56.0),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.video_call),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Yolo on Frame',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.frame;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'YoloV8 on Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.imagev8;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget task(Options option) {
    if (option == Options.frame) {
      return YoloVideo(vision: vision);
    }

    if (option == Options.imagev8) {
      return YoloImageV8(vision: vision);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              "Real Time Detection",
              style: GoogleFonts.bubblegumSans(
                fontSize: 25,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 34),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  speeddialbutton(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class YoloVideo extends StatefulWidget {
  final FlutterVision vision;
  const YoloVideo({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  double confidenceThreshold = 0.5;
  late FlutterVision vision;
  FlutterTts tts = FlutterTts();
  // Variables for speech
  DateTime previousSpeechTime = DateTime.now();
  Duration repeatDuration =
      const Duration(seconds: 10); // Define the repeat duration here
  String previousResult = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return Scaffold(
        body: Center(
          child: Text(
            "Model not loaded, waiting for it...",
            style: GoogleFonts.bubblegumSans(
              fontSize: 18,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(
              controller,
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            bottom: 120,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 5,
                        color: Colors.white,
                        style: BorderStyle.solid),
                  ),
                  child: isDetecting
                      ? IconButton(
                          onPressed: () async {
                            stopDetection();
                          },
                          icon: const Icon(
                            Icons.stop,
                            color: Colors.red,
                          ),
                          iconSize: 50,
                        )
                      : IconButton(
                          onPressed: () async {
                            await startDetection();
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 50,
                        ),
                ),
                const SizedBox(
                  height: 20,
                ), // Add some spacing between the two buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, BottomNavScreen.routeName, (route) => false);
                  },
                  child: const Text('Back to Home Screen'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/detection/labels.txt',
        modelPath: 'assets/detection/yolov8_67mAP_completed_float16.tflite',
        modelVersion: "yolov8",
        numThreads: 1,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await widget.vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      speak() {
        String currentResult = result['tag'].toString();
        DateTime currentTime = DateTime.now();

        if (currentResult != previousResult ||
            currentTime.difference(previousSpeechTime) >= repeatDuration) {
          tts.speak(currentResult);
          previousResult = currentResult;
          previousSpeechTime = currentTime;
        }
      }

      speak();

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100)}",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: const Color.fromARGB(255, 115, 0, 255),
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class YoloImageV8 extends StatefulWidget {
  final FlutterVision vision;
  const YoloImageV8({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloImageV8> createState() => _YoloImageV8State();
}

class _YoloImageV8State extends State<YoloImageV8> {
  late List<Map<String, dynamic>> yoloResults;
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;
  String highestConfidencePrediction = '';
  double highestConfidenceScore = 0.0;

  @override
  void initState() {
    super.initState();
    loadYoloModel().then((value) {
      setState(() {
        yoloResults = [];
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return Scaffold(
        body: Center(
          child: Text(
            "Model not loaded, waiting for it...",
            style: GoogleFonts.bubblegumSans(
              fontSize: 18,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          imageFile != null ? Image.file(imageFile!) : const SizedBox(),
          Positioned(
            bottom: 120.0, // approximately 3 cm
            right: 0,
            left: 0,
            child: Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: pickImage,
                    child: const Text("Pick an image"),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: yoloOnImage,
                    child: const Text("Detect"),
                  ),
                ],
              ),
            ),
          ),
          // ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            top: 50,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                highestConfidencePrediction,
                style: GoogleFonts.bubblegumSans(
                  background: Paint()..color = Colors.yellow,
                  color: Colors.black,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/detection/labels.txt',
        modelPath: 'assets/detection/yolov8_67mAP_completed_float16.tflite',
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }

  yoloOnImage() async {
    yoloResults.clear();
    Uint8List byte = await imageFile!.readAsBytes();
    final image = await decodeImageFromList(byte);
    imageHeight = image.height;
    imageWidth = image.width;

    showLoadingDialog();

    final result = await widget.vision.yoloOnImage(
      bytesList: byte,
      imageHeight: image.height,
      imageWidth: image.width,
      iouThreshold: 0.8,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    Navigator.pop(context); // Close the loading dialog

    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
        var highest = result.reduce(
            (curr, next) => curr['box'][4] > next['box'][4] ? curr : next);
        highestConfidencePrediction = highest['tag'];
        highestConfidenceScore = highest['box'][4];
      });
    }
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(
                  "Processing...",
                  style: GoogleFonts.bubblegumSans(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (imageWidth);
    double imgRatio = imageWidth / imageHeight;
    double newWidth = imageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (imageHeight);

    double pady = (screen.height - newHeight) / 2;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY + pady,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}
