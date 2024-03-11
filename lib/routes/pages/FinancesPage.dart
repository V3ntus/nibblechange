import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinancesPage extends StatefulWidget {
  const FinancesPage({super.key});

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      children: [
        FloatingActionButton.large(
          heroTag: null,
          child: const Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.wallet),
              Text("Budget", style: TextStyle(fontSize: 12)),
            ],
          ),
          onPressed: () => context.go("/"),
        ),
        FloatingActionButton.large(
          heroTag: null,
          child: const Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.list),
              Text("Transactions", style: TextStyle(fontSize: 12)),
            ],
          ),
          onPressed: () => context.go("/"),
        ),
        FloatingActionButton.large(
          heroTag: null,
          child: const Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.loop),
              Text("Recurring", style: TextStyle(fontSize: 12)),
            ],
          ),
          onPressed: () => context.go("/"),
        ),
        FloatingActionButton.large(
          heroTag: null,
          child: const Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.analytics_rounded),
              Text("Analyze", style: TextStyle(fontSize: 12)),
            ],
          ),
          onPressed: () => context.go("/"),
        ),
      ]
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: e,
            ),
          )
          .toList(),
    );
  }
}
