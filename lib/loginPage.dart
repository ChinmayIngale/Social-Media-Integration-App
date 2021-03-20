import 'dart:convert' as JSON;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:social_media_integration/infoPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  String name;
  String id;
  String email;
  String photoUrl;
  String site;

  Map userProfile;
  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: 'kW1Vm6KqI6dyga3f6YJCwGPOT',
    consumerSecret: 'wIKVszODjZE3JVQDoQmukkEWkSqnNLi4DNNH7YtgJ4ONd9sgd4',
  );

  //Google login
  // ignore: non_constant_identifier_names
  void _Googlelogin() async {
    try {
      await _googleSignIn.signIn();
      site = "Google";
      id = _googleSignIn.currentUser.id;
      name = _googleSignIn.currentUser.displayName;
      email = _googleSignIn.currentUser.email;
      photoUrl = _googleSignIn.currentUser.photoUrl;
      navigateToPage(site, id, name, email, photoUrl);
    } catch (err) {
      print(err);
    }
  }

  // ignore: non_constant_identifier_names
  _Facebooklogin() async {
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        Uri myUri = Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        final graphResponse = await http.get(myUri);
        final profile = JSON.jsonDecode(graphResponse.body);
        userProfile = profile;
        site = "Facebook";
        id = userProfile['id'];
        name = userProfile['name'];
        email = userProfile['email'];
        photoUrl = userProfile['picture']['data']['url'];
        navigateToPage(site, id, name, email, photoUrl);
        break;

      case FacebookLoginStatus.cancelledByUser:
        debugPrint('${result.errorMessage}');
        break;
      case FacebookLoginStatus.error:
        debugPrint('${result.errorMessage}');
        break;
    }
  }

  // ignore: non_constant_identifier_names
  void _Twitterlogin() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    //String newMessage;

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        //print('${result.session.userId}');
        //print('${result.session.hashCode}');
        //newMessage = 'Logged in! username: ${result.session.username}';
        var session = result.session;
        final AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: session.token, secret: session.secret);
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((authResult) {
          print(authResult.user);
          site = "Twitter";
          id = authResult.user.uid;
          name = authResult.user.displayName;
          email = authResult.user.email ?? 'null';
          photoUrl = authResult.user.photoURL;
          navigateToPage(site, id, name, email, photoUrl);
        });
        break;
      case TwitterLoginStatus.cancelledByUser:
        debugPrint('${result.errorMessage}');
        break;
      case TwitterLoginStatus.error:
        debugPrint('${result.errorMessage}');
        break;
    }
  }

  navigateToPage(var site, var id, var name, var email, var photoUrl) {
    var fname = name.split(" ");
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => InfoPage(
                site: site,
                id: id,
                name: name,
                fname: fname[0],
                email: email,
                photoUrl: photoUrl)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Column(
          children: [
            Container(
                height: 400,
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
                      child: Text('There',
                          style: TextStyle(
                              fontSize: 65.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto')),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(200, 140, 0, 0),
                      child: Text('.',
                          style: TextStyle(
                              fontSize: 75.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto')),
                    )
                  ],
                )),

            /*Expanded(
    child:*/
            Container(
              height: 300,
              padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          side: BorderSide(width: 2, color: Colors.grey[500]),
                          backgroundColor: Colors.white,
                          minimumSize: Size(600, 60),
                          elevation: 10),
                      onPressed: () {
                        _Googlelogin();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/google.png',
                            height: 50.0,
                            width: 50.0,
                          ),
                          Text(
                            'Login with Google',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[800]),
                          )
                        ],
                      )),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          side: BorderSide(width: 2, color: Colors.blue[800]),
                          backgroundColor: Colors.blue[800],
                          minimumSize: Size(600, 60),
                          elevation: 10),
                      onPressed: () {
                        _Facebooklogin();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/facebook.png',
                            height: 40.0,
                            width: 40.0,
                          ),
                          Text(
                            'Login with Facebook',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )
                        ],
                      )),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          side: BorderSide(width: 2, color: Colors.blue),
                          backgroundColor: Colors.blue,
                          minimumSize: Size(600, 60),
                          elevation: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/twitter.png',
                            height: 40.0,
                            width: 40.0,
                          ),
                          Text(
                            ' Login with Twitter',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )
                        ],
                      ),
                      onPressed: () {
                        _Twitterlogin();
                      })
                ],
              ),
            )
          ],
        ));
  }
}
