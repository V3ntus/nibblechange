import 'package:flutter/material.dart';
import 'package:nibblechange/routes/pages/FinancesPage.dart';
import 'package:nibblechange/routes/pages/HomePage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 1;

  final _pageViewController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("nibblechange"),
      ),
      drawer: const Drawer(),
      body: PageView(
        controller: _pageViewController,
        onPageChanged: (int idx) {
          setState(() {
            currentPageIndex = idx;
          });
        },
        children: [
          const FinancesPage(),
          const HomePage(),
          Container(color: Colors.blue),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          _pageViewController.animateToPage(
            index,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutQuint,
          );
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        indicatorColor: Theme.of(context).primaryColor,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.attach_money), label: "Finances"),
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Setup"),
        ],
      ),
    );
  }
}
