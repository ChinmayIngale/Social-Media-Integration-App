
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InfoPage extends StatefulWidget {
  final site;
  final name;
  final email;
  final photoUrl;
  final id;
  final fname;

  const InfoPage(
      {Key key, this.site, this.id, this.name,this.fname, this.email, this.photoUrl})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _InfoState();
  }
}

class _InfoState extends State<InfoPage> {

  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  FirebaseAuth _auth = FirebaseAuth.instance;
  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: 'kW1Vm6KqI6dyga3f6YJCwGPOT',
    consumerSecret: 'wIKVszODjZE3JVQDoQmukkEWkSqnNLi4DNNH7YtgJ4ONd9sgd4',
  );

  // ignore: non_constant_identifier_names
  _Googlelogout() {
    _googleSignIn.signOut();
  }

  // ignore: non_constant_identifier_names
  _Facebooklogout() {
    facebookLogin.logOut();
  }

  // ignore: non_constant_identifier_names
  _Twitterlogout() async {
    await twitterLogin.logOut();
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SingleChildScrollView(child:Center(
          child: Column(
            children: [
              Container(
                  height: 300,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          end: Alignment.topRight,
                          begin: Alignment.bottomLeft,
                          colors: [Colors.blue, Colors.blue[300]],
                          stops: [0.4, 0.8]),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.elliptical(200, 50),
                          bottomLeft: Radius.elliptical(200, 50))),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 80, 0, 0),
                        child: Text('Hello',
                            style: TextStyle(
                                fontSize: 65.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Roboto')),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 150, 0, 0),
                        child: Text(widget.fname,
                            style: TextStyle(
                                fontSize: 65.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Roboto')),
                      ),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: Column(children: [
                    Text(widget.site,
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto')),
                    //Image.network(widget.photoUrl, height: 200.0, width: 100.0,),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child:CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(widget.photoUrl))
                    ),
                    Text("Id:- " + widget.id,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1
                    )),
                    Text("Name:- " + widget.name,
                        style: TextStyle(
                            fontSize: 18,
                            height: 1.5
                        )),
                    Text("Email:- " + widget.email,
                        style: TextStyle(
                            fontSize: 18,
                            height: 1.5
                        )),
                    ElevatedButton(
                        child: Text("Logout"),
                        onPressed: () {
                          if (widget.site == "Google") {
                            _Googlelogout();
                          } else if (widget.site == "Facebook") {
                            _Facebooklogout();
                          } else if (widget.site == "Twitter") {
                            _Twitterlogout();
                          }
                          Navigator.pop(context);
                              //MaterialPageRoute(
                                //  builder: (context) => LoginPage()));
                        })
                  ]))
            ],
          ),
        )));
  }
}
