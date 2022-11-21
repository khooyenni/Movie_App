import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie World',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movie World'),
        ),
        body: const Center(child: MoviePage()),
      ),
    );
  }
}

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  TextEditingController searchMovie = TextEditingController();
  var title = "",
      actors = "",
      released = "",
      genre = "",
      desc = "",
      imageUrl = "https://tireman.co/assets/img/nodata.png";

  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchMovie,
            onChanged: (newValue) {
              setState(() {
                title = newValue.toString();
              });
            },
            decoration: InputDecoration(
                hintText: 'Enter movie title',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ),
        ),
        ElevatedButton(
            onPressed: _searchConfirmation, child: const Text("Search")),
        const SizedBox(height: 20),
        Image.network(imageUrl),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(desc,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ]),
          ),
        )
      ])),
    );
  }

  void _searchConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Confirmation",
          ),
          content: const Text(
            "Are you sure you want to search this movie?",
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _getMovie();
              },
            ),
            TextButton(
              child: const Text(
                "No",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getMovie() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress....."), title: const Text("Searching Movie"));
    progressDialog.show();

    var apiid = "2e811de8";
    var url = Uri.parse('https://www.omdbapi.com/?t=$title&apikey=$apiid');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        imageUrl = parsedJson['Poster'];
        title = parsedJson['Title'];
        String released = parsedJson['Released'];
        String genre = parsedJson['Genre'];
        String actors = parsedJson['Actors'];
        desc =
            "Title: $title\nReleased: $released\nGenre: $genre\nActors: $actors";
      });
      progressDialog.dismiss();
      loadDone();
      Fluttertoast.showToast(
          msg: "Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else {
      setState(() {
        desc = "No record";
      });
    }
  }

  Future loadDone() async {
    await player.play(AssetSource('sounds/success.wav'));
  }
}
