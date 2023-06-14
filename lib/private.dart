import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PrivateChat extends StatefulWidget {
  final String idChat;
  final String sender;
  const PrivateChat({required this.idChat, required this.sender, Key? key}) : super(key: key);

  @override
  PrivateChatState createState() => PrivateChatState();
}

class PrivateChatState extends State<PrivateChat> {
  final storage = const FlutterSecureStorage();
  final dio = Dio();
  late Future<List?> _chats;
  late String token;
  late String user;

  final _msgController = TextEditingController();

  Future<List?> getChats() async {
    if(await storage.containsKey(key: 'token') == false) {
      return null;
    }
    else {
      final response = await dio.get("https://kripto-chat.vercel.app/listMessage", queryParameters: {"idChat": widget.idChat}, options: Options(headers: {'Authorization': "Bearer ${await storage.read(key: 'token')}"}));
      if (response.statusCode == 200) {
        return response.data["messages"];
      }
      else {
        return null;
      }
    }
  }

  void send() async {
    final _updatedChats;
    final response = await dio.post(
      "https://kripto-chat.vercel.app/sendMessage",
      data: {"messageIn": _msgController.text, "messageOut": _msgController.text, "idChat": widget.idChat},
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': "Bearer ${await storage.read(key: 'token')}"
        }
      )
    );
    if (response.statusCode == 200) {
      _updatedChats = getChats();

      setState(() {
        _chats = Future.value(_updatedChats);
      });

      print("message sent");
    }
    else {
      print("message not sent");
    }
  }

  void getJWT() async {
    token = (await storage.read(key: 'token'))!;
    user = Jwt.parseJwt(token)["user1"];
  }

  Future<void> refresh() async {
    final updatedChats = getChats();

    setState(() {
      _chats = Future.value(updatedChats);
    });

    print("refreshed");
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _chats = getChats();
    getJWT();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(248, 250, 236, 1),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(44, 61, 99, 1),
            title: Text(widget.sender),
          ),
          body: Stack(
            children: [
              FutureBuilder<List?>(
                future: _chats,
                builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.bouncingBall(color: const Color.fromRGBO(44, 61, 99, 1), size: 12),
                    );
                  }
                  else if (snapshot.hasData) {
                    final chats = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      itemCount: chats.length,
                      itemBuilder:  (BuildContext context, int index) {
                        final chat = chats[index];
                        if (user != chat["idSender"]) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(chat["idSender"], style: TextStyle(fontSize: 16),),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: const BoxDecoration(color: Color.fromRGBO(44, 61, 99, 1), borderRadius: BorderRadius.all(Radius.circular(12))),
                                  child: Text(chat["messageIn"], style: TextStyle(fontSize: 18, color: Colors.white),),
                                ),
                                const SizedBox(height: 6,)
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
                                  decoration: const BoxDecoration(color: Color.fromRGBO(44, 61, 99, 1), borderRadius: BorderRadius.all(Radius.circular(12))),
                                  child: Text(chat["messageIn"], style: TextStyle(fontSize: 18, color: Colors.white),),
                                ),
                                const SizedBox(height: 6,)
                              ],
                            )
                          );
                        }
                      }
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  else {
                    return const Center(
                      child: Text("No data available"),
                    );
                  }
                }
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(12),
                  color: Color.fromRGBO(44, 61, 99, 1),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _msgController,
                          style: TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          send();
                          _msgController.clear();
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(40, 55, 89, 1)),),
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
