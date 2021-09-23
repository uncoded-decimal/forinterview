import 'package:flutter/material.dart';

class DefaultLoader extends StatelessWidget {
  const DefaultLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
