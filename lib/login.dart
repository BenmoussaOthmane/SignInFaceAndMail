import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoggedIn = false;
  bool _isLoadingSignin = false;
  bool _isLoadingFace = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  final _nameControler = TextEditingController();
  final _emailControler = TextEditingController();
  final _passwordControler = TextEditingController();
  final _phoneControler = TextEditingController();

  _loginWithFB() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(result);
        // print(token);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
          _isLoadingSignin = false;
          _isLoadingFace = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  _logout() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //     child: _isLoggedIn
      //         ? Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               Image.network(
      //                 userProfile["picture"]["data"]["url"],
      //                 height: 50.0,
      //                 width: 50.0,
      //               ),
      //               Text(userProfile["name"]),
      //               OutlineButton(
      //                 child: Text("Logout"),
      //                 onPressed: () {
      //                   _logout();
      //                 },
      //               )
      //             ],
      //           )
      //         : Center(
      //             child: OutlineButton(
      //               child: Text("Login with Facebook"),
      //               onPressed: () {
      //                 _loginWithFB();
      //               },
      //             ),
      //           )),
      backgroundColor: Color(0xFFF3F3F3),
      body: Container(
        height: MediaQuery.of(context).size.height / 1,
        width: MediaQuery.of(context).size.width / 1,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoggedIn
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isLoadingSignin
                        ? Column(
                            children: [
                              Text(
                                'Hi  '+_nameControler.text,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                _emailControler.text,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                _phoneControler.text,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              OutlineButton(
                                child: Text("Logout"),
                                onPressed: () {
                                  _logout();
                                },
                              )
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.network(
                                userProfile["picture"]["data"]["url"],
                                height: 50.0,
                                width: 50.0,
                              ),
                              Text('Hi  '+userProfile["name"]),
                              OutlineButton(
                                child: Text("Logout"),
                                onPressed: () {
                                  _logout();
                                },
                              )
                            ],
                          )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(25.0),
                      height: MediaQuery.of(context).size.height / 1.3,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400].withOpacity(.8),
                              offset: Offset(5.0, 5.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                                color: Color(0xFF212121),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Name',
                            ),
                            controller: _nameControler,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            controller: _emailControler,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                            ),
                            obscureText: true,
                            controller: _passwordControler,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                            ),
                            controller: _phoneControler,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isLoggedIn = true;
                                _isLoadingSignin = true;
                                _isLoadingFace = false;
                              });
                            },
                            child: Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width / 1,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width / 1,
                            child: OutlineButton(
                              child: Text("Login with Facebook"),
                              onPressed: () {
                                _loginWithFB();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
