import 'package:flutter/material.dart';
import 'package:hffa/layout/login.dart';
import 'package:hffa/layout/register.dart';
import 'package:hffa/layout/transaction.dart';
import 'package:hffa/layout/calculator.dart';

class LayoutWidget extends StatelessWidget {
  const LayoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: Colors.white, // Tab indicator color
              labelColor: Colors.black, // Selected icon color
              unselectedLabelColor: Colors.white, // Unselected icon color
              tabs: [
                Tab(
                  icon: Icon(Icons.login),
                  text: 'Login',
                ),
                Tab(
                  icon: Icon(Icons.app_registration_rounded),
                  text: 'Register',
                ),
                Tab(
                  icon: Icon(Icons.article_outlined),
                  text: 'Transaction',
                ),
                Tab(
                  icon: Icon(Icons.calculate),
                  text: 'Calculator',
                )
              ],
            ),
            title: const Text('Harini Fertilizers',
                style: TextStyle(
                    fontSize: 24, // Sets the font size
                    fontWeight: FontWeight.bold)), // Makes the text italic

            centerTitle: true,
            backgroundColor: Colors.teal),
        body: TabBarView(
          children: [LoginPage(), RegisterForm(), TxnForm(), TxnSearchForm()],
        ),
      ),
    );
  }
}
