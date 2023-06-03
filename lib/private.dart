import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PrivateChat extends StatefulWidget {
  final String idChat;
  const PrivateChat({required this.idChat, Key? key}) : super(key: key);

  @override
  PrivateChatState createState() => PrivateChatState();
}

class PrivateChatState extends State<PrivateChat> {
  final storage = const FlutterSecureStorage();
  final dio = Dio();
  late Future<List?> _chats;
  
  Future<List?> getChats() async {
    if(await storage.containsKey(key: 'token') == false) {
      return null;
    }
    else {
      final response = await dio.get("https://kripto-chat.vercel.app/listMessage", queryParameters: {"idChat": widget.idChat}, options: Options(headers: {'Authorization': "Bearer ${await storage.read(key: 'token')}"}));
      if (response.statusCode == 200) {
        print("berhasil ges");
        // return response.data["chats"];
      }
      else {
        return null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _chats = getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 250, 236, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 61, 99, 1),
      ),
      body: FutureBuilder<List?>(
        future: _chats,
        builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.bouncingBall(color: const Color.fromRGBO(44, 61, 99, 1), size: 12),
            );
          }
          else if (snapshot.hasData) {
            final chats = snapshot.data!;
            print("berhasil ges");
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder:  (BuildContext context, int index) {
                final chat = chats[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: ,
                );
              }
            );
          }
          else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          else {
            return Center(
              child: Text("No data available"),
            );
          }
        }
      )
    );
  }
}