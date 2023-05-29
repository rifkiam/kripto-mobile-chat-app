import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
{
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';
  final dio = Dio();
  final storage = const FlutterSecureStorage();

  Future<void> sendRequest() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await dio.post(
        "https://kripto-chat.vercel.app/login",
        data: {"username": _username.text, "password": _password.text},
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        )
      );

      if (response.statusCode == 200) {
        if (storage.containsKey(key: 'token') != Null) {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {return SuccessPage();}));
        }
        else {
          storage.write(key: 'token', value: response.data.toString());
          // Navigator.push(context, MaterialPageRoute(builder: (context) {return SuccessPage();}));
        }
      }
      else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to submit the form.';
        });
      }
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    double ScreenWidth = MediaQuery.of(context).size.width;
    double ScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _isLoading ? const Center(child: CircularProgressIndicator()) :
      Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
            width: ScreenWidth,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/bg.jpeg"), fit: BoxFit.fitHeight)),
            child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    // crossAxisAlignment: CrosAxisAlignment.center,
                    children: [
                      Text("Chatchit", style: TextStyle(fontWeight: FontWeight.w800, color: Color.fromRGBO(44, 61, 99, 1), fontSize: 24)),
                      SizedBox(height: ScreenHeight/3.75),
                      Text("Login", style: TextStyle(fontWeight: FontWeight.w800, color: Color.fromRGBO(44, 61, 99, 1), fontSize: 20)),
                      SizedBox(height: 8,),
                      TextFormField(
                        controller: _username,
                        decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(fontWeight: FontWeight.w500)
                        ),
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Please enter a valid username';
                          }
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _password,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontWeight: FontWeight.w500)
                        ),
                        obscureText: true,
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Enter the corresponding password';
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: sendRequest,
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(44, 61, 99, 1))),
                        child: const Text('Submit'),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));},
                        child: RichText(text: TextSpan(text: "Don't have an account? ", style: TextStyle(color: Color.fromRGBO(44, 61, 99, 1)), children: [
                          TextSpan(
                              text: "Click here",
                              style: TextStyle(color: Color.fromRGBO(68, 109, 200, 1), fontWeight: FontWeight.w700)
                          )
                        ])),
                      ),
                    ],
                  ),
                )
            )
        ),
      )
    );
  }
}