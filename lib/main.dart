import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppScreen(),
    );
  }
}

class AppScreen extends StatefulWidget {
  @override
  ApiScreenState createState() => ApiScreenState();
}

class ApiScreenState extends State<AppScreen> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
      });
    } else {
      throw Exception("Failed to load data");
    }
  } // Closing brace for fetchData

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HTTP Request"),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(posts[index]['title']),
            subtitle: Text(posts[index]['body']),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DetailedScreen(post: posts[index])));
            },
          );
        },
      ),
    );
  }
}

class DetailedScreen extends StatelessWidget {
  final dynamic post;

  DetailedScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post detail"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post['title'], style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Text(post['body'], style: TextStyle(fontSize: 16)),
              ],
            )
        )
    );
  }

}