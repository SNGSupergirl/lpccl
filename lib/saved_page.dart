//   saved_page.dart

import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved"),
      ),
      body: const Center(
        child: Text("Saved Page"),
      ),
    );
  }
}