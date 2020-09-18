import 'package:flutter/material.dart';

class JdText extends StatelessWidget {
  String holderText;
  Function onChangeValue;
  bool isSecure;
  JdText({
    Key key,
    @required this.holderText,
    this.onChangeValue,
    this.isSecure = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
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
