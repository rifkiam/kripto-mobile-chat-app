import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
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
  late String token;
  late String user;
  
  Future<List?> getChats() async {
    if(await storage.containsKey(key: 'token') == false) {
      return null;
    }
    else {
      final response = await dio.get("https://kripto-chat.vercel.app/listMessage", queryParameters: {"idChat": widget.idChat}, options: Options(headers: {'Authorization': "Bearer ${await storage.read(key: 'token')}"}));
      if (response.statusCode == 200) {
        // print("berhasil ges");
        print(response.data["messages"]);
        return response.data["messages"];
      }
      else {
        return null;
      }
    }
  }

  void getJWT() async {
    token = (await storage.read(key: 'token'))!;
    user = Jwt.parseJwt(token)["user1"];
  }

  @override
  void initState() {
    super.initState();
    _chats = getChats();
    getJWT();
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
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              itemCount: chats.length,
              itemBuilder:  (BuildContext context, int index) {
                final chat = chats[index];
                late int pos;

                if (user != chat["idSender"]) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chat["idSender"], style: TextStyle(fontSize: 16),),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Text(chat["messageIn"], style: TextStyle(fontSize: 18, color: Colors.white),),
                          decoration: BoxDecoration(color: Color.fromRGBO(44, 61, 99, 1), borderRadius: BorderRadius.all(Radius.circular(12))),
                        ),
                        SizedBox(height: 6,)
                      ],
                    )

                  );
                }
                else {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(chat["idSender"], style: TextStyle(fontSize: 16),),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Text(chat["messageIn"], style: TextStyle(fontSize: 18, color: Colors.white),),
                          decoration: BoxDecoration(color: Color.fromRGBO(44, 61, 99, 1), borderRadius: BorderRadius.all(Radius.circular(12))),
                        ),
                        SizedBox(height: 6,)
                      ],
                    )
                  );
                }

                // return Container(
                //   padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                //   child: ,
                // );
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