import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'private.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatRoom extends StatefulWidget
{
  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom>
{
  final storage = const FlutterSecureStorage();
  final dio = Dio();
  late Future<List?> _contacts;

  Future<List?> getData() async {
    if(await storage.containsKey(key: 'token') == false) {
      return null;
    }
    else {
      final response = await dio.get("https://kripto-chat.vercel.app/getChat", options: Options(headers: {'Authorization': "Bearer ${await storage.read(key: 'token')}"}));
      // return await storage.read(key: 'token');
      if (response.statusCode == 200) {
        return response.data["chats"];
      }
      else {
        return null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _contacts = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 250, 236, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 61, 99, 1),
      ),
      body: FutureBuilder<List?>(
        future: _contacts,
        builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.bouncingBall(color: const Color.fromRGBO(44, 61, 99, 1), size: 12),
            );
          }
          else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          else if (snapshot.hasData) {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                final contact = contacts[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, style: BorderStyle.solid, width: 1))),
                  child: InkWell(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) {return PrivateChat(idChat: contact["idChat"],);}));},
                    child: Text(contact["username"], style: TextStyle(fontSize: 18)),
                  ),
                );
              }
            );
          }
          else {
            return Text('No data available'); // Fallback widget when there is no data
          }
        }
      )
    );
  }
}