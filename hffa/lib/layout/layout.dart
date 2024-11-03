import 'package:flutter/material.dart';
import 'package:hffa/layout/login.dart';
import 'package:hffa/layout/register.dart';
import 'package:hffa/layout/transactions.dart';

class LayoutWidget extends StatelessWidget {
  const LayoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: Colors.white, // Tab indicator color
              labelColor: Colors.yellow, // Selected icon color
              unselectedLabelColor: Colors.white54, // Unselected icon color
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Harini Fertilizers'),
            centerTitle: true,
            backgroundColor: Colors.teal),
        body: const TabBarView(
          children: [LoginWidget(), RegisterWidget(), TransactionsWidget()],
        ),
      ),
    );
  }
}
