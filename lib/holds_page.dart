//   holds_page.dart

import 'package:flutter/material.dart';

class HoldsPage extends StatelessWidget {
  const HoldsPage({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Holds"),
      ),
      body: const Center(
        child: Text("Holds Page"),
      ),
    );
  }
}