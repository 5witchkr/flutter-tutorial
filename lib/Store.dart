import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';


//provider data
class Store1 extends ChangeNotifier {
  int follower = 0;
  bool isfollower = false;
  //함수store
  addFollower(){
    if (isfollower){
      follower--;
      isfollower = false;
    } else {
      follower++;
      isfollower = true;
    }
    //재랜더링
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier {
  String name = 'username';
}

//get 받아온 data store저장
class Store3 extends ChangeNotifier {
  dynamic profileImage = [];

  getData() async {
    dynamic result = await http.get(Uri.parse('https:'));
    dynamic result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }
}