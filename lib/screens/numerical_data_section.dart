import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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

  fetchprediction(String url) async {
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return jsonDecode(response.body);
  }

  String prediction = "No detection yet";

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
                  hintText: "Sex  (male/female)",
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
                      "http://197.239.10.96:8000/Predict?Sex=${sexController.text}&Age=${ageController.text}&Height=${heightController.text}&Weight=${weightController.text}";
                  // 197.239.10.96
                  //172.20.10.2
                  //192.168.137.111
                  //127.0.0.1
                  // "http://10.0.2.2:8000/Predict?Sex=${sexController.text}&Age=${ageController.text}&Height=${heightController.text}&Weight=${weightController.text}";
                });
                var fetcheddata = await fetchprediction(requesturl);

                var loadeddata = fetcheddata;

                setState(() {
                  prediction = loadeddata[0];
                });
              },
              child: const Text("Make Detection"),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(prediction.toUpperCase(),
                style: GoogleFonts.bubblegumSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ))
          ],
        ),
      ),
    );
  }
}
