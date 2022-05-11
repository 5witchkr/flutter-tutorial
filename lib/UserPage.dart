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
      body: CustomScrollView(
        //Customscrollview - slivers안에있는것들 합쳐서 스크롤을 만들어줌
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (c, i) => Container(color: Colors.greenAccent),
                childCount: 10,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3)),
        ]
      )
    );
  }
}


class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로워 ${context
            .watch<Store1>()
            .follower}명'),
        ElevatedButton(onPressed: () {
          //provider Store1 funtion 사용
          context.read<Store1>().addFollower();
        }, child: Text('팔로우')),
        ElevatedButton(onPressed: () {
          context.read<Store3>().getData();
        }, child: Text('사진가져오기')),
      ],
    );
  }
}