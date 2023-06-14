import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'private.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'chatroom.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  AddFriendState createState() => AddFriendState();
}

class AddFriendState extends State<AddFriend> {
  final _controller = TextEditingController();
  final storage = const FlutterSecureStorage();
  final dio = Dio();
  // final textFieldKey = GlobalKey<FormFieldState<String>>();
  late String token;
  String _errorMessage = '';

  Future<void> addFriend() async{
    final response = await dio.post(
      "https://kripto-chat.vercel.app/add",
      data: {"username": _controller.text},
      options: Options(
        headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Authorization': "Bearer ${await storage.read(key: 'token')}"}
      )
    );
    if(response.data["statusCode"] == 200 && response.statusCode == 200) {
      print("object");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()),);
    }
    else if(response.data["statusCode"] == 404 || response.data["statusCode"] == 409) {
      _errorMessage = "Username not found";
    }

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
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
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