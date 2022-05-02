import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage}) : super(key: key);
  //userImage를 부모객체에서 받아옴
  final userImage;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('이미지 업로드 화면'),
          TextField(),
        ],
      )
    );
  }
}