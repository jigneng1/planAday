import 'package:flutter/material.dart';

class BookmarkPlanScreen extends StatelessWidget {
  const BookmarkPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: const Text("Bookmarks Plan"),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("Bookmarks Plan"),
      ),
    );
  }
}


