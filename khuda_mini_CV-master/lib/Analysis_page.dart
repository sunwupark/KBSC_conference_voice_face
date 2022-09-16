import 'package:flutter/material.dart';


class Analysis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('분석하기',
            style: TextStyle(
            fontFamily: "DoHyeon"
        )
      ),
        centerTitle: true,
          backgroundColor: Colors.green[700]
      ),
    );
  }
}