import 'package:flutter/material.dart';

import 'inwards_tab.dart';
import 'outwards_tab.dart';
import 'persons_tab.dart';
import 'stock_tab.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Persons'),
              Tab(text: 'Inwards'),
              Tab(text: 'Outwards'),
              Tab(text: 'Stock'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PersonsTab(),
            InwardsTab(),
            OutwardsTab(),
            StockTab(),
          ],
        ),
      ),
    );
  }
}
