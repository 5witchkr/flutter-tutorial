import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
//스크롤 관련 함수 패키지
import 'package:flutter/rendering.dart';
import './Upload.dart';
//이미지피커
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(
    //materialapp위젯 사용함 (option : title, theme, home)
    MaterialApp(
      //option
      //theme? css같은 역할
      theme: style.themeAppBar,
      home: MyApp()
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    //scafflod 위젯 리턴
    return Scaffold(
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

