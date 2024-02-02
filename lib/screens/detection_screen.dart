// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malnudetect/constants/global_variables.dart';
import 'package:malnudetect/methods/auth_methods.dart';
import 'package:malnudetect/screens/numerical_data_section.dart';
import 'package:tflite/tflite.dart';

class Result {
  final String label;
  final double confidence;
  Result(this.label, this.confidence);
}

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({Key? key}) : super(key: key);

  @override
  _DetectionScreenState createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  late File _image;
  late List _results;
  // late List<Result> _results;
  bool imageSelect = false;
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
      model: "assets/models/firstmodelwith2outputs.tflite",
      labels: "assets/models/labels.txt",
    ))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      _image = image;
      imageSelect = true;
    });
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
    Navigator.pop(context);
  }

//get image from camera
  Future<void> _getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    File imagefile = File(image.path);
    imageClassification(imagefile);

    Navigator.pop(context);
  }

//options for image selection
  void _showImageOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return GiffyDialog.image(
          Image.network(
            "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
            height: 200,
            fit: BoxFit.cover,
          ),
          title: const Text(
            'Image Selection',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Please provide the photo of your child while they are STANDING',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _getImageFromCamera;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: GlobalVariables.primaryColor,
              ),
              child: Center(child: Text('Some Contents')),
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                AuthMethods().signOut();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          (imageSelect)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.file(_image),
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: const Opacity(
                    opacity: 0.8,
                    child: Center(
                      child: Text("No image selected"),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _showImageOptions,
                      child: Card(
                        elevation: 9,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                          ),
                          child: const Icon(Icons.image),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: (imageSelect)
                  ? _results.map((result) {
                      return Card(
                        elevation: 20,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            // "${result.label}: ${result.confidence.toStringAsFixed(1)}%",
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
          ),
          const SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            child: Column(
              children: imageSelect
                  ? _results.map((result) {
                      return Container(
                        child: result["label"] == "Malnourished"
                            ? Column(
                                children: [
                                  const Text("Solutions"),
                                  Container(
                                    height: 100,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    )),
                                  ),
                                  const SizedBox(height: 40),
                                  Text(
                                      "Input Child Details for further analysis",
                                      style: GoogleFonts.risque(
                                          color: Colors.teal)),
                                  const NumericalSection()
                                ],
                              )
                            : const SizedBox(),
                      );
                    }).toList()
                  : [],
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showImageOptions,
      //   tooltip: "Pick Image",
      //   child: const Icon(Icons.image),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }
}
