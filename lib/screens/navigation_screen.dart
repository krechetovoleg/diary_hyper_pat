import 'package:diary_hyper_pat/screens/data_screen.dart';
import 'package:diary_hyper_pat/screens/graph_screen.dart';
import 'package:diary_hyper_pat/screens/sett_screen.dart';
import 'package:diary_hyper_pat/screens/stat_screen.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;
  final screens = [
    const DataScreen(),
    const GraphScreen(),
    const StatScreen(),
    const SettScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPageIndex,
        onTap: (index) => setState(() {
          currentPageIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: "Данные",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: "График",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats_outlined),
            label: "Статистика",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Настройки",
          ),
        ],
        //selectedItemColor: Colors.black54,
        //unselectedItemColor: Colors.grey.withOpacity(0.5),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        elevation: 0.0,
      ),
      body: screens[currentPageIndex],
    );
  }
}
