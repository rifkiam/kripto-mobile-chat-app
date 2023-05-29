import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage>
{
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';
  final dio = Dio();

  Future<void> sendRequest() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await dio.post(
        "https://kripto-chat.vercel.app/register",
        data: {"username": _username.text, "password": _password.text},
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        )
      );

      if (response.statusCode == 200) {
        // Kalau berhasil
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
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
          width: ScreenWidth,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/bg.jpeg"), fit: BoxFit.fitHeight)),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Chatchit", style: TextStyle(fontWeight: FontWeight.w800, color: Color.fromRGBO(44, 61, 99, 1), fontSize: 24)),
                  SizedBox(height: ScreenHeight/3.75),
                  Text("Register", style: TextStyle(fontWeight: FontWeight.w800, color: Color.fromRGBO(44, 61, 99, 1), fontSize: 20)),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: _username,
                    decoration: const InputDecoration(
                      labelText: 'Username',
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
                    ),
                    obscureText: true,
                    validator: (value) {
                      if(value!.isEmpty) {
                        return 'Enter the corresponding password';
                      }
                    },
                  ),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: sendRequest,
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(44, 61, 99, 1))),
                    child: const Text('Submit'),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));},
                    child: RichText(text: TextSpan(text: "Already have an account? ", style: TextStyle(color: Color.fromRGBO(44, 61, 99, 1)), children: [
                      TextSpan(
                        text: "Click here",
                        style: TextStyle(color: Color.fromRGBO(68, 109, 200, 1), fontWeight: FontWeight.w700)
                      )
                    ])),
                  )
                ],
              ),
            )
          )
        ),
      )
    );
  }
}