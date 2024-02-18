import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:malnudetect/constants/global_variables.dart';
import 'package:malnudetect/screens/solution_section_screen.dart';

class NumericalSection extends StatefulWidget {
  const NumericalSection({super.key});

  @override
  State<NumericalSection> createState() => _NumericalSectionState();
}

class _NumericalSectionState extends State<NumericalSection> {
  TextEditingController sexController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    sexController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
  }

  String requesturl = "";
  bool isloading = false;
  bool detectionAchieved = false;

  fetchprediction(String url) async {
    setState(() {
      isloading = true;
    });

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      isloading = false;
    });

    return jsonDecode(response.body);
  }

  String prediction = "No detection yet";
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter child's sex";
                  }

                  return null;
                },
                controller: sexController,
                decoration: const InputDecoration(
                  hintText: "Sex  (Male/Female)",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter child's age";
                  }

                  return null;
                },
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Age (yrs)",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter child's height";
                  }

                  return null;
                },
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Height (cm)",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter child's weight";
                  }

                  return null;
                },
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Weight (Kgs)",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  requesturl =
                      "http://10.0.2.2:8000/Predict?Sex=${sexController.text}&Age=${ageController.text}&Height=${heightController.text}&Weight=${weightController.text}";
                  //pc ip ==  192.168.43.3
                  //pc ip ==  102.85.9.80  .........
                  // 197.239.10.96
                  //172.20.10.2
                  //192.168.137.111
                  //127.0.0.1
                  //tecno phone ip  ==  10.219.182.45
                  //tecno phone ip  ==  10.169.36.212
                  //emulator phone ip  ==  10.0.2.2
                  // "http://10.0.2.2:8000/Predict?Sex=${sexController.text}&Age=${ageController.text}&Height=${heightController.text}&Weight=${weightController.text}";
                });
                var fetcheddata = await fetchprediction(requesturl);

                var loadeddata = fetcheddata;

                setState(() {
                  prediction = loadeddata[0];
                  detectionAchieved = true;
                });
              },
              child: const Text("Make Detection"),
            ),
            const SizedBox(
              height: 30,
            ),
            !detectionAchieved
                ? Text("Input Child Details for further Detection",
                    style: GoogleFonts.bubblegumSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("DETECTED AS",
                          style: GoogleFonts.bubblegumSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(width: 5),
                      Text(prediction.toUpperCase().split(" ").last,
                          style: GoogleFonts.bubblegumSans(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
            detectionAchieved
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Text(
                          "Solutions",
                          style: GoogleFonts.bubblegumSans(
                              fontSize: 25, color: Colors.blue),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 250,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                              color: GlobalVariables.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              )),
                          child: SingleChildScrollView(
                            child: SolutionsSection(
                                prediction:
                                    prediction.toUpperCase().split(" ").last),
                          ),
                        ),
                      ],
                    ),
                  )
                //SolutionsSection()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
