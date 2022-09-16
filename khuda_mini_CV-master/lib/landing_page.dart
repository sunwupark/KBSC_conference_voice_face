import 'package:flutter/material.dart';
import 'package:khuda_miniproject/constant.dart';
import 'package:khuda_miniproject/home_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:khuda_miniproject/main.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CommuHelper',
                    style: TextStyle(
                        fontFamily: "DoHyeon",
                        fontSize: 50,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 32.0),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/landing_pic3.jpg'),
                    radius: 100.0,
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(builder: (_) => HomePage())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[700], // Background color
                    ),
                    child: const Text(
                      '시작하기 버튼',
                      style: TextStyle(
                          fontSize: 40
                      ),
                    ),
                  ),
                ]
            )
        )
    );
  }
}