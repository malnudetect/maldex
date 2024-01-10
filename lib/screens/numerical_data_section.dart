import 'package:flutter/material.dart';

class NumericalSection extends StatefulWidget {
  const NumericalSection({super.key});

  @override
  State<NumericalSection> createState() => _NumericalSectionState();
}

class _NumericalSectionState extends State<NumericalSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Sex",
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
            child: const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Age",
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
            child: const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Weight",
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
            child: const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Height",
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
