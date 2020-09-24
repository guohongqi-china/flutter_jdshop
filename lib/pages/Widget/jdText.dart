import 'package:flutter/material.dart';

class JdText extends StatelessWidget {
  String holderText;
  Function onChangeValue;
  bool isSecure;
  int maxLines;
  double tfHeight;
  TextEditingController controller;
  JdText(
      {Key key,
      @required this.holderText,
      this.onChangeValue,
      this.isSecure = false,
      this.maxLines = 1,
      this.tfHeight = 68,
      this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.tfHeight,
      child: TextField(
        controller: this.controller,
        maxLines: this.maxLines,
        obscureText: this.isSecure, // 是否明文显示
        decoration: InputDecoration(
            hintText: this.holderText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            )),
        onChanged: this.onChangeValue,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
    );
  }
}
