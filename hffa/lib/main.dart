import 'package:flutter/material.dart';
import 'package:hffa/layout/layout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAl0ra3F7-p_77Czgw8lS9fISW2WBeO_iI",
      authDomain: "hffa-3ea40.firebaseapp.com",
      projectId: "hffa-3ea40",
      storageBucket: "hffa-3ea40.appspot.com",
      messagingSenderId: "595514369377",
      appId: "1:595514369377:web:e14b9878ccae0ce5499120",
      measurementId: "G-6WZN6JDQ0X",
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalData(),
      child: const MainWidget(),
    ),
  );
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

class GlobalData extends ChangeNotifier {
  bool _isUserLoggedIn = false;

  bool get isUserLoggedIn => _isUserLoggedIn;

  void setIsUserLoggedIn(bool isUserLoggedIn) {
    _isUserLoggedIn = isUserLoggedIn;
    notifyListeners();
  }
}
