import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class AppBarHeadPage extends StatelessWidget {
  Function tapAction;
  String title;

  AppBarHeadPage({this.tapAction, this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapAction,
      child: Container(
        height: ScreenAdapter.height(50),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.8),
            borderRadius: BorderRadius.circular(ScreenAdapter.height(50) / 2)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Colors.grey,
            ),
            Text(
              this.title,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}
