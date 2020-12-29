import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internApp/screens/homepage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internApp/screens/loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Container(
              child: Center(
                child: Text("Something Went Wrong"),
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Container(
                    child: Center(
                      child: Text("Something Went Wrong"),
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;
                if (user == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
              } else {
                return Scaffold(
                  body: Container(
                    child: Center(
                      child: Text("Something Went Wrong"),
                    ),
                  ),
                );
              }
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: SpinKitFadingCircle(
              color: Colors.white,
              size: 50.0,
            ),
          ),
        );
      },
    );
  }
}
