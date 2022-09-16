import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_color/random_color.dart';

// http
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'landing_page.dart';

//Camera List를 만든다
late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Permission을 받아준다. 음성녹음: microphone, 카메라: camera, 저장공간: manageExternalStorage
  Map<Permission, PermissionStatus> statuses = await [
    Permission.microphone,
    Permission.camera,
    Permission.manageExternalStorage
    //add more permission to request here.
  ].request();

  _cameras = await availableCameras();
  runApp(const MyApp());
}


/// CameraApp is the Main Application.
/// 분석하기 버튼의 기능을 구현한 클래스이다
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({Key? key}) : super(key: key);
  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with SingleTickerProviderStateMixin{
  ///카메라 컨트롤러 선언
  late CameraController controller;
  //AnimationController _animationController;
  /// 색상의 변화를 위한 AnimationController 선언 (감정에 따라 색깔이 달라질 것이다)
  late AnimationController _controller = AnimationController(vsync: this, duration: Duration(seconds: 1),)..  repeat(reverse: true);
  late Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  /// 데일리 레포트를 위한 voice, image 감정 리스트
  List<dynamic> voice_list = [];
  List<dynamic> image_list = [];

  /// 시작 감정 색상, 추후 setState를 통해 색상을 바꿔줄 것이다
  var returncolor = Colors.white;

  /// 음성녹음을 위한 FlutterSoundRecorder 선언
  final recorder = FlutterSoundRecorder();

  /// filepath 변수
  var filepathplease = "";

  /// 시작, 중지로 변환을 위한 버튼 actice 선언
  var active = false;

  /// server ip 선언
  final ip = '172.30.1.41:5000';

  /// 분석하기 창에서 처음, Name, Voice, Image 시작값을 선언 해준다
  var output = "아직은 데이터가 부족합니다";
  var img_output = "아직은 데이터가 부족합니다";
  var img_name = "unknown";

  /// 일반 경로
  var filepath = '';


  /// 음성녹음 init 함수이다. recorder를 열어준다
  Future initRecorder() async {
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }


  /// Stard Record 함수를 실행하면 바로 recording을 시작한다
  Future startRecord() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    String vaiable = now.toString();
    await recorder.startRecorder(toFile: vaiable.substring(0,10));
  }


  /// Stop Recorder를 누르면 file로 저장을 하고 이를 handlePost 함수를 이용하여 서버로 보내고 response를 output에 넣어준다
  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    print('Recorded file path: $filePath');

    final response = await  handlePost5('audio', filePath);
    print('${response['statusCode']} : ${response['result']}');
    setState(() {output=response['result'];
    voice_list.add([response['time'], response['result']]);});
  }

  /// handlePost함수에 path를 넣어주면 Post로 서버에 데이터를 전달해준다
  Future handlePost5(type, path) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://${ip}/'));
    request.files.add(
        await http.MultipartFile.fromPath(type, '${path}'));
    var res = await request.send();
    final responseData = await res.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final response = json.decode(responseString);
    return (response);
  }


  /// handlePost함수에 path를 넣어주면 Post로 서버에 데이터를 전달해준다
  Future handlePost(type, path) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://${ip}/'));
    request.files.add(
        await http.MultipartFile.fromPath(type, '${path}'));
    var res = await request.send();
    final responseData = await res.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final response = json.decode(responseString);
    return (response);
  }


  /// 사진을 찍는 함수이다. 사진을 찍고 바로 handlePost로 서버에 사진을 보내고 그에대한 감정, Color, 대상의 이름을 return으로 받고
  /// setState함수에서 이들을 할당해준다
  Future handleScreenshot() async {
      var img_path;
      img_path = await controller.takePicture();
      final response = await handlePost('image', img_path.path);
      print('${response['statusCode']} : ${response['result']}');
      print(response['name']);
      print(response['color']);
      setState(() {
        img_output = response['result'];
        img_name = response['name'];
        returncolor = Color(int.parse(response['color'], radix: 16)).withOpacity(1.0);
        image_list.add([response['time'], response['result'].toString()]);
      });
  }


  /// 이 class를 실행을 하였을때 CameraController를 실행한다
  @override
  void initState() {
    super.initState();
    initRecorder();
    //_animationController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    //_animationController.repeat(reverse: true);

    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }


  ///음성녹음 recorder와 camera controller를 다 dispose해준다
  @override
  void dispose() {
    recorder.closeRecorder();
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  String printText(var arr)
  {
    var m = Map();

    for (int i=0; i<arr.length; i++)
    {
      if (m[arr[i][1]] == null)
        m[arr[i][1]] = 0;
      m[arr[i][1]] += 1;
    }
    var max = -1;
    var max_arg = '';
    double probability = 0.0;
    for (var i in m.keys)
    {
      if (m[i] > max) { max_arg = i; max = m[i]; };
    }
    probability = max/arr.length;
    var returnvalue = '\nEmotion: ${max_arg}, \nProbability: ${probability}\n';
    return returnvalue;
  }

   ///위에 선언된 함수들을 전체적으로 실행하는 함수이다
  handlePressed() async {
    setState(() {
      active = !active;
      if(active == false){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Daily Report"),
                content: Stack(
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Form(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Image Data: "),
                            ),
                            Column(
                              children: [
                                for (var i in image_list) Text(i.toString())
                              ],
                            ),
                            Column(
                              children: [
                                Text(printText(image_list))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("\n\Voice Data: \n"),
                            ),
                            Column(
                              children: [
                                for (var i in voice_list) Text(i.toString())
                              ],
                            ),
                            Column(
                              children: [
                                Text(printText(voice_list)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(primary: Colors.transparent),
                                child: Text("Exit"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  image_list = [];
                                  voice_list = [];
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      }
    });
    while (active){
      await handleScreenshot();
      await startRecord();
      await Future.delayed(Duration(seconds: 10));
      await stopRecorder();
    }

  }

  /// 분석하기 창을 구성하는 요소들이다
  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Container(
      child: Column(
          children:[
            Container(
              color: Colors.white,
              //margin: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text('How you Feel?', style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: 900,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Colors.white
                      ),
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: CameraPreview(controller),
                          height: 700,
                          ),
                      ],
                    ),
                  ),
                  //SizedBox(width: 20.0, height: 20.0),
                  Positioned(
                    left: 162,
                    bottom: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white70, shape: CircleBorder()),
                            child: Image(image: !active? AssetImage('assets/play.png') : AssetImage('assets/stop2.png')),
                            onPressed: () async {
                              await handlePressed();
                            }),
                  ),
                  Positioned(
                    bottom: 100,
                    child: Column(
                      children: [
                        Text(style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color:Colors.white
                        ), textAlign: TextAlign.center ,"Name: " + img_name),
                        Text(style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color:Colors.white
                        ), textAlign: TextAlign.center ,"image: " + img_output),
                        Text(style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color:Colors.white
                        ), textAlign: TextAlign.center ,"voice: " + output)
                      ],
                    )

                  ),
                ]
              ),
            ),
        ]),
    );
    }
  }


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(title: Text('CommuHelper'),
        actions: [
          IconButton(icon: Icon(Icons.question_mark_outlined), onPressed: () =>
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Daily Report"),
                      content: Stack(
                        children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                child: Icon(Icons.close),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          Form(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("By Analayzing Your Face Expression and Your Speaking We were able to evaluate your conversation level. We are going to show how negatie or positive your conversation were"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(primary: Colors.transparent),
                                      child: Text("Exit"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
          )]),

      body : CameraApp()
    );
    }
}

class MainPage2 extends StatefulWidget {
  const MainPage2({Key? key}) : super(key: key);

  @override
  State<MainPage2> createState() => _MainPage2State();
}


class _MainPage2State extends State<MainPage2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar : AppBar(title: Text('CommuHelper'),),
        body : Camera2App()
    );
  }
}

class Camera2App extends StatefulWidget {
  /// Default Constructor
  const Camera2App({Key? key}) : super(key: key);
  @override
  State<Camera2App> createState() => _CameraApp2State();
}

class _CameraApp2State extends State<Camera2App> {
  late CameraController controller;
  final myController = TextEditingController();
  var filepathplease = "";
  var active = false;
  final ip = '172.30.1.41:5000';
  var img_name = "unknown";
  var filepath = '';
  var returnvalue = -1;
  var returntext = "";

  Future handleScreenshot2(name) async {
    var img_path;
    var file_name;
    img_path = await controller.takePicture();
    //print("file name: " + file_name);
    final response = await handlePost2('image', img_path.path, name);
    setState(() {
      returnvalue = response['statusCode'];
      if(returnvalue == -1){
        returntext = "등록에 실패했습니다";
      }
      else if(returnvalue == -2){
        returntext = "이미 존재하는 이름입니다";
      }
      else {
        returntext = "등록에 성공하였습니다";
      }
    });
  }

  Future handlePost2(type, path, name) async {
    final directory = await getApplicationDocumentsDirectory();
    String paths = directory.path;
    File file = File('$paths/$name.txt'); //
    file.writeAsString("$name");

    // 1
    var request = http.MultipartRequest('POST', Uri.parse('http://${ip}/'));
    request.files.add(
        await http.MultipartFile.fromPath(type, '${path}'));

    print("file123!@#!@#!@#!#!@#@!#!@#: " + file.path.toString());

    request.files.add(
        await http.MultipartFile.fromPath("text", file.path));


    var res = await request.send();
    final responseData = await res.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final response = json.decode(responseString);
    return (response);
  }

  @override
  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  void _printLatestValue() {
    print("Name field: ${myController.text}");
  }

  @override
  void dispose() {
    controller.dispose();
    myController.dispose();
    super.dispose();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.grey,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
          children:[
            Container(
              alignment: Alignment.center,
                child: SizedBox(
                  width: 400,
                  height: 700,
                  child: CameraPreview(controller),
                ),
              ),
            Positioned(
              bottom: 20,
                child: Column(
                  children: [
                    Container(
                      width: 250,
                      child: TextField(controller: myController, decoration: InputDecoration(
                        hintText: "input your name", hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 1.0)),
                      ), style: TextStyle(fontSize: 20, color: Colors.white),),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white30, shape: CircleBorder()),
                        onPressed: () async {await handleScreenshot2(myController.text); showToast(returntext);},
                      child: Image(image: AssetImage('assets/screenshot-64.png'),width: 80,))
                  ],
                ),
                )

    ],
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute : '/',
        theme: ThemeData(
            primarySwatch : Colors.blue,
            scaffoldBackgroundColor: Colors.white
        ),
        //라우팅
        routes : {
          '/' : (context) => LandingPage(),
        }
    );
  }
}
