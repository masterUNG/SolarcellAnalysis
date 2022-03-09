// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:solacellanalysin/widgets/show_text.dart';

class ShowCard extends StatelessWidget {
  final double size;
  final String label;
  final String pathImage;
  const ShowCard({
    Key? key,
    required this.size,
    required this.label,
    required this.pathImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Card(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShowText(label: label),
            SizedBox(width: size - 50,
              child: Image.asset(pathImage),
            ),
          ],
        ),
      ),
    );
  }
}
