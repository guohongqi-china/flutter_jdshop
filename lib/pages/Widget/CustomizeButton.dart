import 'package:flutter/material.dart';

class CustomizeButton extends StatelessWidget {
  Color bgColor;
  String text;
  Function callback;

  CustomizeButton(
      {Key key,
      this.bgColor = Colors.black,
      this.text = "按钮",
      @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.callback,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        alignment: Alignment.center,
        child: Text(this.text,
            style: TextStyle(
              color: Colors.white,
            )),
        decoration: BoxDecoration(
          color: this.bgColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }
}
