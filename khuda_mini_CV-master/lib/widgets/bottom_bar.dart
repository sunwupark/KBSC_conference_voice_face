import 'package:flutter/material.dart';
import 'package:khuda_miniproject/Analysis_page.dart';
import 'package:khuda_miniproject/Registering_person.dart';
import 'package:khuda_miniproject/main.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.green[700], //선택된 아이템의 색상
        selectedFontSize: 15.0,
        unselectedFontSize: 15.0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: '분석하기'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_front),
              label: '사람 등록하기'
          )
        ],
      selectedLabelStyle: TextStyle(
        fontFamily: "DoHyeon"
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: "DoHyeon"
      ),
      onTap: (idx) async {
          if(idx==0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (__)=> MainPage())
            );
          }
          else if(idx==2) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (__)=> MainPage2())
            );
          }
      }
    );
  }
}