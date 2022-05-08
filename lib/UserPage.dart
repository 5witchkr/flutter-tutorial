import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'main.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //provider Store1.name data사용
      appBar: AppBar(title: Text(context.watch<Store2>().name),),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          Text('팔로워 ${context.watch<Store1>().follower}명'),
          ElevatedButton(onPressed: () {
            //provider Store1 funtion 사용
            context.read<Store1>().addFollower();
          }, child: Text('팔로우'))
        ],
      ),
    );
  }
}
