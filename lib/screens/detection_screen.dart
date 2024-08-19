// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malnudetect/common/loading.dart';
import 'package:malnudetect/constants/global_variables.dart';
import 'package:malnudetect/methods/auth_methods.dart';
import 'package:malnudetect/realtimedetection/main.dart';
import 'package:malnudetect/screens/login_screen.dart';
import 'package:malnudetect/screens/numerical_data_section.dart';
// import 'package:tflite/tflite.dart';

class Result {
  final String label;
  final double confidence;
  Result(this.label, this.confidence);
}

enum Options { none, imagev8, frame, vision }

class DetectionScreen extends StatefulWidget {
  static const routeName = "/detection-screen";

  const DetectionScreen({Key? key}) : super(key: key);

  @override
  _DetectionScreenState createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  late File _image;
  late List _results;
  bool loading = false;
  bool imageSelect = false;

  late FlutterVision vision;

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeYoloModel();
  }

  Widget task(Options option) {
    if (option == Options.frame) {
      return YoloVideo(vision: vision);
    }

    if (option == Options.imagev8) {
      return YoloImageV8(vision: vision);
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              (!imageSelect)
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      child: const Opacity(
                        opacity: 0.8,
                        child: SizedBox(),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.all(10),
                      child: Image.file(_image),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 56,
                  vertical: 100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    speeddialbutton(),
                  ],
                ),
              ),
              Column(
                children: (imageSelect)
                    ? _results.map((result) {
                        return Card(
                          elevation: 20,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Text(
                              "${result["label"]}: ${(result["confidence"] * 100).toStringAsFixed(1)}%",
                              style: TextStyle(
                                color: result["label"] == "Healthy"
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    : [],
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: imageSelect
                    ? _results.map((result) {
                        return Container(
                          child: result["label"] == "Malnourished"
                              ? Column(
                                  children: [
                                    const SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                          "Input Child Details for further analysis",
                                          style: GoogleFonts.risque(
                                            color: Colors.teal,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const NumericalSection(),
                                  ],
                                )
                              : const SizedBox(),
                        );
                      }).toList()
                    : [],
              )
            ],
          ),
        ),
      ],
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            height: 100,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Loading(),
                SizedBox(height: 20),
                Text("Loading result please wait...",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return userDoc.data() as Map<String, dynamic>;
  }

  Options option = Options.none;
  late List<CameraDescription> cameras;

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
        // SpeedDialChild(
        //   //speed dial child
        //   child: const Icon(Icons.video_call),
        //   backgroundColor: Colors.red,
        //   foregroundColor: Colors.white,
        //   label: 'Real-Time',
        //   labelStyle: const TextStyle(fontSize: 18.0),
        //   onTap: () {
        //     setState(() {
        //       option = Options.frame;
        //     });
        //   },
        // ),
        SpeedDialChild(
          child: const Icon(Icons.camera),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          label: 'Detect on Image',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () {
            setState(() {
              option = Options.imagev8;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        title: Text(
          "MalDex",
          style: GoogleFonts.bubblegumSans(
            fontSize: 34,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  var userData = snapshot.data!;
                  return Column(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(userData['username']),
                        accountEmail: Text(userData['email']),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage(userData['photoUrl']),
                        ),
                      ),
                      ListTile(
                        title: const Text('Home'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                AuthMethods().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: task(option),
    );
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _showImageOptions,
                    child: const Text("Select image"),
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
            const SizedBox(
              height: 20,
            ),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(23)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageFile != null
                            ? Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width -
                                      60, // Adjust as needed
                                  maxHeight:
                                      MediaQuery.of(context).size.height /
                                          2, // Adjust as needed
                                ),
                                child: Image.file(imageFile!),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            highestConfidencePrediction.toUpperCase(),
                            style: GoogleFonts.bubblegumSans(
                              fontWeight: FontWeight.bold,
                              color:
                                  highestConfidencePrediction.toLowerCase() ==
                                          "healthy"
                                      ? Colors.green
                                      : Colors.red,
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Container(
              child: highestConfidencePrediction.toLowerCase() == "malnourished"
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child:
                              Text("Input Child Details for further analysis",
                                  style: GoogleFonts.risque(
                                    color: Colors.teal,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const NumericalSection(),
                      ],
                    )
                  : const SizedBox(),
            ),

            // ...displayBoxesAroundRecognizedObjects(size),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
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
        highestConfidencePrediction = ''; // Reset the prediction
        highestConfidenceScore = 0.0; // Reset the confidence score
        yoloResults.clear();
      });
      Navigator.pop(context); // Close the image selection dialog
    }
  }

  Future<void> _getImageFromCamera() async {
    // final image = await ImagePicker().pickImage(source: ImageSource.camera);
    // if (image == null) return;

    // setState(() {
    //   imageFile = File(image.path);
    //   highestConfidencePrediction = ''; // Reset the prediction
    //   highestConfidenceScore = 0.0; // Reset the confidence score
    //   yoloResults.clear();
    // });

    // Navigator.pop(context); // Close the image selection dialog

    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
        highestConfidencePrediction = ''; // Reset the prediction
        highestConfidenceScore = 0.0; // Reset the confidence score
        yoloResults.clear();
      });
      Navigator.pop(context); // Close the image selection dialog
    }
  }

  void _showImageOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return GiffyDialog.image(
          Image.asset(
            "assets/images/gif14.gif",
            height: 200,
            fit: BoxFit.cover,
          ),
          title: const Text(
            'Image Selection',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Please provide a colored photo of your child',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _getImageFromCamera();
              },
              child: const Text('CAMERA'),
            ),
            TextButton(
              onPressed: () {
                pickImage();
              },
              child: const Text('GALLERY'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
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
