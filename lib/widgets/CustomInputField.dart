import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomInputField extends StatelessWidget {
  final String label;
  final saveHandler;
  final obscureText;
  final keyboardType;
  final TextEditingController controller;
  Function validatorHandler;

  CustomInputField({
    @required this.label,
    this.saveHandler,
    this.obscureText: false,
    this.keyboardType,
    this.validatorHandler,
    this.controller,
  }) {
    if (validatorHandler == null) {
      validatorHandler = (String val) {
        if (val.isEmpty) return 'Field cannot be empty';
        return null;
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        SizedBox(height: 6),
        Container(
          width: 280,
          height: 60,
          margin: EdgeInsets.only(bottom: 10),
          // padding: EdgeInsets.symmetric(vertical: 15),
          child: TextFormField(
            controller: controller,
            onSaved: saveHandler,
            keyboardType: keyboardType,
            textInputAction: TextInputAction.next,
            validator: validatorHandler,
            obscureText: obscureText,
            style: TextStyle(
              color: Colors.black,
            ),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              helperText: ' ',
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.only(left: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.black, width: 2)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide:
                    BorderSide(color: Theme.of(context).errorColor, width: 1),
              ),
              hintStyle: TextStyle(fontSize: 1.0, color: Colors.black38),
            ),
          ),
        ),
      ],
    );
  }
}
