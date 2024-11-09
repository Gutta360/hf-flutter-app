import 'package:flutter/material.dart';
import 'package:hffa/layout/layout.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainWidget());
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.outfitTextTheme(textTheme).copyWith(
            bodyMedium: GoogleFonts.outfit(textStyle: textTheme.bodyMedium),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: LayoutWidget());
  }
}
