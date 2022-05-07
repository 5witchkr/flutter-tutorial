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
      appBar: AppBar(title: Text(context.watch<Store1>().name),),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
            //provider Store1 funtion 사용
            context.read<Store1>().changeName();
          }, child: Text('버튼'))
        ],
      ),
    );
  }
}
