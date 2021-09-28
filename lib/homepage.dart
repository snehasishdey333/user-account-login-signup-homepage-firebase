import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_account/start.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoggedIn = false;

  checkAuthentication() async {
    _auth
      ..authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Start()));
        }
      });
  }

  void getUser() async {
    user = await _auth.currentUser;
    await user!.reload();
    user = await _auth.currentUser;
    //await user?reload();

    if (user != null) {
      setState(() {
        this.user = user;
        this.isLoggedIn = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: !isLoggedIn
            ? CircularProgressIndicator()
            : Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 200,
                    child: Image(
                      image: AssetImage('images/5.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    child: Text(
                      'Hello ${user!.displayName} you are logged in as ${user!.email}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                    onPressed: signOut,
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.red,
                  )
                ],
              ),
      ),
    );
  }
}
