// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ShowForm extends StatelessWidget {
  final String hint;
  final TextInputType? textInputType;
  final Function(String) changeFunc;
  const ShowForm({
    Key? key,
    required this.hint,
    this.textInputType,
    required this.changeFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      height: 40,
      child: TextFormField(onChanged: changeFunc,
        keyboardType: textInputType ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
