import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisteringPersonPage extends StatefulWidget {
  @override
  RegisteringPerson createState() => RegisteringPerson();

  const RegisteringPersonPage({Key? key}) : super(key: key);
}



class RegisteringPerson extends  State<RegisteringPersonPage> {
  final TextEditingController _textController = new TextEditingController();
  Widget _changedTextWidget = Container();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사람 등록하기',
            style: TextStyle(
                fontFamily: "DoHyeon"
            )
        ),
        centerTitle: true,
          backgroundColor: Colors.green[700]
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: _buildTextWidget()
      )
    );
  }

  Widget _buildTextWidget() {
    return Container(
        child: Column(
            children:[
              Row(
                children: [
                  Flexible(
                      child: TextField(
                          controller: _textController,
                          onSubmitted: (text) {
                            sendMsg(text);
                          },
                          onChanged: (text) {
                            checkText(text);
                          },
                          decoration: InputDecoration(
                              hintText: '등록하려는 사람의 이름을 입력해주세요',
                              border: OutlineInputBorder(),
                              suffixIcon: _textController.text.isNotEmpty
                                    ? Container(
                                        child: IconButton(
                                          alignment: Alignment.centerRight,
                                          icon: Icon(
                                            Icons.cancel,
                                          ),
                                          onPressed: () {
                                            _textController.clear();
                                            setState(() {});
                                          },
                                        ),
                                       )
                                    : null
                          ),
                      ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      sendMsg(_textController.text);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.lightGreen[100],
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ),
                      child: Container(
                        height: 50,
                        width: 100,
                        alignment: Alignment.center,
                        child: Text(
                            'SEND'
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    left: 30,
                    right: 30,
                    bottom: 500,
                  ),
                  alignment: Alignment.center,
                  color: Colors.lightGreen[500],
                  child: _changedTextWidget,
                ),
              )
            ],
        ),

    );
  }

  void sendMsg(String text) {
    _textController.clear();
    Fluttertoast.showToast(
      msg: '등록되었습니다 : $text',
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void checkText(String text) {
    _changedTextWidget = Container(
      child: Text.rich(
        TextSpan(
          text: '등록되었습니다 : ',
          style: TextStyle(
            color: Colors.black
          ),
          children: [
            TextSpan(
              text: '$text',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ],
        )
      )
    );
    setState( () {} );
  }
}




