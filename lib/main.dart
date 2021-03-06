import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
//스크롤 관련 함수 패키지
import 'package:flutter/rendering.dart';
//page import
import './Upload.dart';
import './UserPage.dart';
//store import
import './Store.dart';
//이미지피커
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//shared_preferences
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//provider
import 'package:provider/provider.dart';
//notification
import 'notification.dart';




void main() {
  runApp(
    //provider store1, store2를 모든 위젯에서 사용함
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => Store1()),
        ChangeNotifierProvider(create: (c) => Store2()),
        ChangeNotifierProvider(create: (c) => Store3()),
      ],
      //materialapp위젯 사용함 (option : title, theme, home)
      child: MaterialApp(
        //option
        //theme? css같은 역할
        theme: style.themeAppBar,
        home: MyApp()
      ),
    )
  );
}

//state사용
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //tab의  state
  int stateTab = 0;
  dynamic data = [];
  dynamic userImage;

  //shared_preferences
  saveData() async {
    dynamic storage = await SharedPreferences.getInstance();
    //save  setSring말고 다른거도 가능 ex)bool,num? .. 등
    storage.setString('key','value');
    //use data
    dynamic storageResult = storage.get('key');
    //map 자료? jsonEncode, jsonDecode로 변환후 사용
    dynamic mapdata = {'myNumber' : 777};
    storage.setString('mapkey', jsonEncode(mapdata));
    dynamic resultmapdata = storage.getString('mapkey') ?? 'nullcheck?';
    print(jsonDecode(resultmapdata)['myNumber']);
    //log
    print(storageResult);
    //remove data
    storage.remove('key');
  }



  //get http (async-await를 사용하기위해 getData함수에 담아줌)
  getData() async {
    dynamic result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    // print(result.body);

    // if (result.statusCode == 200) {
    //   print('성공');
    // } else {
    //   print('실패');
    // }

    // //map(key-val)으로 파싱
    // print(jsonDecode(result.body));
    data = jsonDecode(result.body);
  }
  //initState - getData() 함수 사용
  @override
  void initState() {
    super.initState();

    //storage 실행되는지 확인
    saveData();
    //notification
    initNotification(context);

    getData();
  }

  @override
  Widget build(BuildContext context) {
    //scafflod 위젯 리턴
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('알림'), onPressed: (){
        showNotification();
      },),
      //appbar (네비바)
      appBar: AppBar(
          title: Text('R9Sgram'),
          actions: [
            IconButton(
                icon: Icon(Icons.add_box_outlined),
                //상단 네비바 버튼 누르면 네이게이터(새페이지)생성
                onPressed: () async {
                  //imagePicker
                  dynamic picker = ImagePicker();
                  dynamic image = await picker.pickImage(source: ImageSource.gallery);
                  //이미지 널체크 한 뒤 userImage state에 저장
                  if ( image != null ) {
                    setState(() {
                      //state에 저장
                      userImage = File(image.path);
                    });
                  }

                  Navigator.push(context,
                    //upload쪽으로 userImage 보내줌
                    MaterialPageRoute(builder: (context) => Upload(userImage: userImage) )
                  );
                },
                iconSize: 30,
            ),
          ]),
      //본문에 text
      //List형식으로 tab 보여줄것임 (if써도됨)
      //Home자식위젯에 data를 넣어줌.
      body: [Home(data : data), Text('샵페이지')][stateTab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //onTap .. i는 0,1,2... 순서대로 부여됨
        onTap: (i){
          //state를 바꿔주려면 setstate를 사용해야함
          setState(() {
            stateTab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '설명 홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '설명 샵'),
        ],
      ),
    );
  }
}

//stateful widget으로 변경해줬음
//(등록은 첫 클래스(Home클래스) 사용은 두번째 _HomeState 클래스에서부터 사용)
class Home extends StatefulWidget {
  //this.data로 사용선언
  const Home({Key? key, this.data}) : super(key: key);
  //부모객체에서 받아온 data
  final data;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //scroll 변수
  dynamic scroll = ScrollController();

  //scroll initState
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Listenner ? 변수값이 변할때마다 코드실행
   scroll.addListener(() {
      print(scroll.position.pixels);
      print(scroll.position.userScrollDirection);

    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      print(widget.data);
      return ListView.builder(itemCount: 3, controller: scroll,itemBuilder: (c, i){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.data[i]['image']),
              //gestureDetector 특정동작을 위젯에 입힐때 사용
              GestureDetector(
                child: Text(widget.data[i]['user']),
                onTap: (){
                  //page open
                  Navigator.push(context,
                    //pageroutebuilder (custom page animation)
                    PageRouteBuilder(pageBuilder: (c, a1, a2) => UserPage(),
                    transitionsBuilder: (c, a1, a2, child) =>
                        SlideTransition(
                          position: Tween(
                          begin: Offset(-1.0, 0.0),
                          end: Offset(0.0, 0.0),
                        ).animate(a1),
                        child: child,
                        )
                    )
                  );
                },
              ),
              Text('좋아요 ${widget.data[i]['likes']}'),
              Text(widget.data[i]['date']),
              Text(widget.data[i]['content']),
            ]
        );
      });
    } else {
      return Text('로딩중입니다...');
    }
  }
}

