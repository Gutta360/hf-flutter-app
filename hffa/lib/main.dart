import 'package:flutter/material.dart';
import 'package:hffa/layout/layout.dart';

void main() {
  runApp(const MainWidget());
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const LayoutWidget());
  }
}
