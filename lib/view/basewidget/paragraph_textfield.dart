import 'package:flutter/material.dart';

Widget peragraphTextField({
  @required String title,
  TextEditingController controller,
  @required BuildContext context,
  Function validatorFunction,
  VoidCallback onTap,
  Function onChange,
  bool readOnly = false,
  TextInputType textInputType = TextInputType.text,
  String initialValue,
  String labelText,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: TextFormField(
      validator: (input) {
        if (validatorFunction != null) {
          return validatorFunction(input);
        } else {
          return null;
        }

        // if (input!.isEmpty) {
        //   return "Field can't be empty";
        // }
        // return null;
      },
      maxLines: 4,
      initialValue: initialValue,
      readOnly: readOnly,
      keyboardType: textInputType,
      controller: controller,
      onTap: onTap,
      onChanged: onChange,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        helperStyle: TextStyle(color: Colors.blue),
        hintText: title,
        hintStyle: TextStyle(color: Colors.blue),
        counterStyle: TextStyle(color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
