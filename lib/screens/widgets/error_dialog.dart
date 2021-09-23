import 'package:flutter/material.dart';

void showErrorDialog(
  BuildContext context, {
  required String errorTitle,
  required String errorMessage,
}) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      titlePadding: const EdgeInsets.all(8),
      title: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          errorTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
      ),
      content: Text(
        errorMessage,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
          style: ButtonStyle(
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
        ),
      ],
    ),
  );
}
