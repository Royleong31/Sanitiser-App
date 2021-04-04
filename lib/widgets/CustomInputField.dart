import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  CustomInputField({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        SizedBox(height: 6),
        Container(
          width: 280,
          height: 41,
          child: TextFormField(
            // controller: controller,
            // onSaved: saveHandler,
            // keyboardType: (keyboardType == 'number')
            //     ? TextInputType.number
            //     : TextInputType.text,
            textInputAction: TextInputAction.next,
            // validator: validatorHandler,
            // obscureText: obscureText,
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.all(10),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.black)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.black),
              ),
              hintStyle: TextStyle(fontSize: 1.0, color: Colors.black38),
            ),
          ),
        ),
      ],
    );
  }
}
