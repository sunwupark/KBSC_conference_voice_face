import 'package:flutter/material.dart';

class SearchScreenState extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/');
                },
                 child: Text(
                   "S.O.S",
                   style: TextStyle(fontSize: 20.0),
                   ),
                   style: ElevatedButton.styleFrom(
                     primary: Colors.red[200],
                     shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        elevation: 0.0
                   ),
                 ),
          ],
        ) ,)
      );

  }
}