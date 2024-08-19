import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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

  fetchprediction2(String url) async {
    print('++++++++++++++++++++++ request url $url');
    setState(() {
      isloading = true;
    });

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("_------------------------- response: $response");

    setState(() {
      isloading = false;
    });

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> fetchprediction(String url) async {
    print('++++++++++++++++++++++ request url $url');
    setState(() {
      isloading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print("_------------------------- response: ${response.body}");

      setState(() {
        isloading = false;
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Failed to load prediction'};
      }
    } catch (error) {
      setState(() {
        isloading = false;
      });
      print('Error fetching prediction: $error');
      return {'error': 'Error fetching prediction'};
    }
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

                  if (value.toLowerCase() != "male" &&
                      value.toLowerCase() != "female") {
                    return "Please enter either 'Male' or 'Female'";
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

                  int? age = int.tryParse(value);
                  if (age == null || age < 1 || age > 5) {
                    return "Please enter an age between 1 and 5 years";
                  }

                  return null;
                },
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Age (1-5yrs) ",
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
                // Validate the form fields before making the detection
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, proceed with the detection
                  setState(() {
                    requesturl =
                        "https://renderersvm.onrender.com/Predict?Sex=${sexController.text}&Age=${ageController.text}&Height=${heightController.text}&Weight=${weightController.text}";
                  });

                  var fetcheddata = await fetchprediction(requesturl);

                  if (fetcheddata.containsKey('error')) {
                    setState(() {
                      prediction = fetcheddata['error'];
                      detectionAchieved = false;
                    });
                  } else if (fetcheddata.containsKey('Detected as')) {
                    setState(() {
                      prediction = fetcheddata['Detected as'];
                      detectionAchieved = true;
                    });
                  } else {
                    setState(() {
                      prediction = "Unexpected error occurred";
                      detectionAchieved = false;
                    });
                  }
                } else {
                  print("Form is not valid, please correct the errors");
                }
              },
              child: const Text("Make Detection"),
            ),
            const SizedBox(
              height: 30,
            ),
            !detectionAchieved
                ? Text("",
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
                      Text(
                        prediction.toUpperCase().split(" ").last,
                        style: GoogleFonts.bubblegumSans(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            detectionAchieved
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8, 40, 8, 30),
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
                              color: const Color.fromARGB(255, 101, 186, 255),
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
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
