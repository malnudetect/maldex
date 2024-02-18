// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SolutionsSection extends StatefulWidget {
  final String prediction;
  const SolutionsSection({
    Key? key,
    required this.prediction,
  }) : super(key: key);

  @override
  State<SolutionsSection> createState() => _SolutionsSectionState();
}

class _SolutionsSectionState extends State<SolutionsSection> {
  @override
  Widget build(BuildContext context) {
    switch (widget.prediction) {
      case "STUNTING":
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "✅ Give Breast Milk For 6 Months In Babies.\n✅ Fulfill Nutritional Needs Since Pregnancy.\n✅ Child Development Monitor.\n✅ Healthy Complementary Foods.\n✅ Always Maintain Environmental Cleanliness.",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.left,
            softWrap: true,
            style: GoogleFonts.bubblegumSans(
              fontSize: 20,
            ),
          ),
        );
      case "UNDERWEIGHT":
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "✅ Give Breast Milk For 6 Months In Babies.\n✅ Fulfill Nutritional Needs Since Pregnancy.\n✅ Child Development Monitor.\n✅ Healthy Complementary Foods.\n✅ Always Maintain Environmental Cleanliness.",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.left,
            softWrap: true,
            style: GoogleFonts.bubblegumSans(
              fontSize: 20,
            ),
          ),
        );
      case "OVERWEIGHT":
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "✅ Support Obesity Prevention in Early Care and Education.\n✅ Model a Healthy Eating Pattern.\n✅ Move More as a Family.\n✅ Set Consistent Sleep Routines.\n✅ Replace Screen Time with Family Time.",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.left,
            softWrap: true,
            style: GoogleFonts.bubblegumSans(
              fontSize: 20,
            ),
          ),
        );
      case "WASTING":
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Consult doctor for Ready-to-Use Therapeutic Food (RUTF)",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.left,
            softWrap: true,
            style: GoogleFonts.bubblegumSans(
              fontSize: 20,
            ),
          ),
        );

      default:
        return const Text("Solution DOesn't Exist");
    }
  }
}
