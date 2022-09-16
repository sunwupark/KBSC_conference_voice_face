import'package:flutter/material.dart';
import 'package:khuda_miniproject/constant.dart';

import 'package:khuda_miniproject/Analysis_page.dart';
import 'package:khuda_miniproject/Registering_person.dart';
import 'package:khuda_miniproject/loading_page.dart';
import 'widgets/bottom_bar.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'CommuHelper',
              style: TextStyle(
                  fontFamily: "DoHyeon",
                  color:Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 25.0,
              ),
            ),
            centerTitle: true,
            elevation: 0.0,
            toolbarHeight: 70,
            backgroundColor: Colors.green[700]
        ),
        drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.grey[850],
                  ),
                  title: Text('메인 페이지',
                      style: TextStyle(
                          fontFamily: "DoHyeon"
                      )
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[850],
                  ),
                  title: Text('분석하기',
                      style: TextStyle(
                          fontFamily: "DoHyeon"
                      )
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => MainPage()
                    ));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_front,
                    color: Colors.grey[850],
                  ),
                  title: Text('사람 등록하기',
                      style: TextStyle(
                          fontFamily: "DoHyeon"
                      )
                  ),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => MainPage2()
                    ));
                  },
                ),
              ],
            )
        ),
        body: SafeArea(
            child: Scaffold(
              body: ListView(
                padding: const EdgeInsets.all(40),
                children: [
                  Container(width : 50, height : 50, color: Colors.white),
                  SizedBox(
                    height:150,
                    width:200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => MainPage()
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[600], // Background color
                      ),
                      child: Column(
                        children: [
                          Image.asset('assets/analysis.png',width:80,height:80),
                          Container(height:10,color:Colors.yellow[600]),
                          const Text(
                            '분석하기',
                            style: TextStyle(
                                fontFamily: "DoHyeon",
                                fontSize: 40,
                                color: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width : 50, height : 50, color: Colors.white),
                  SizedBox(
                    height:150,
                    width:200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => MainPage2()
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreen[200], // Background color
                      ),
                      child: Column(
                        children: [
                          Image.asset('assets/registering.png',width:80,height:80),
                          const Text(
                            '사람 등록하기',
                            style: TextStyle(
                                fontFamily: "DoHyeon",
                                fontSize: 40,
                                color: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width : 50, height : 40, color: Colors.white),
                ],
              ),
              bottomNavigationBar: SizedBox(
                  height:70.0,
                  child: BottomBar()
              ),

            )
        )
    );
  }
}

class _HomePageMenu extends StatelessWidget {
  final Color color;
  final String text;
  final void Function() onClick;

  _HomePageMenu({
    required this.color,
    required this.text,
    required this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          height: 100,
          color: color,
          child: Center(
              child: Text(
                  text,
                  style: TextStyle(
                      color:Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal
                  )
              )
          )
      ),
      onTap: onClick,
    );
  }
}