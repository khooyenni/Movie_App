import 'dart:async';

import 'package:flutter/material.dart';

import 'movie.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});

  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => const MainPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 161, 234, 182),
          child: SingleChildScrollView(child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/images/p.png', scale: 0.5),
              const SizedBox(height: 10),
              Image.asset('assets/images/Eating.gif', scale: 0.2),
              const SizedBox(height: 20),
              const Text("Welcome to Movie World!",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 60),
              const CircularProgressIndicator(
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
