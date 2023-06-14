import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'private.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  AddFriendState createState() => AddFriendState();
}

class AddFriendState extends State<AddFriend> {
  final _controller = TextEditingController();

  Future<void> addFriend() async{

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 250, 236, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(44, 61, 99, 1),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenWidth/6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Add Friend by Username!", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
              SizedBox(height: 8),
              TextField(
                controller: _controller,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: addFriend,
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(44, 61, 99, 1))),
                child: const Text('Add!'),
              ),
            ],
          ),
        )
      )
    );
  }

}