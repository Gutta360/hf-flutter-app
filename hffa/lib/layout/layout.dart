import 'package:flutter/material.dart';
import 'package:hffa/layout/login.dart';
import 'package:hffa/layout/register.dart';
import 'package:hffa/layout/transaction.dart';
import 'package:hffa/layout/calculator.dart';

class LayoutWidget extends StatefulWidget {
  const LayoutWidget({super.key});

  @override
  _LayoutWidgetState createState() => _LayoutWidgetState();
}

class _LayoutWidgetState extends State<LayoutWidget> {
  bool isLoggedIn = false;

  void handleLoginSuccess() {
    setState(() {
      isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
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
              ),
            ],
          ),
          title: const Text(
            'Harini Fertilizers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: TabBarView(
          children: [
            LoginPage(onLoginSuccess: handleLoginSuccess), // Pass callback
            isLoggedIn ? RegisterForm() : _buildDisabledTab(),
            isLoggedIn ? TxnForm() : _buildDisabledTab(),
            isLoggedIn ? TxnSearchForm() : _buildDisabledTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledTab() {
    return Center(
      child: Text(
        'Please log in to access this tab.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
