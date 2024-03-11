import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunchmoney/lunchmoney.dart';
import 'package:nibblechange/components/PulsatingCardPlaceholder.dart';
import 'package:nibblechange/components/dashboard/TransactionsLineChart.dart';
import 'package:nibblechange/global_handler.dart';
import 'package:nibblechange/main.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month - (DateTime.now().day >= 15 ? 0 : 1), 1);
  DateTime endDate = DateTime.now();

  List<Transaction>? transactions;

  void fetchTransactions() async {
    setState(() {
      transactions = null;
    });
    final result = await globalHandler.lunchMoney.transactions.transactions(
      startDate: startDate,
      endDate: endDate,
    );
    setState(() {
      transactions = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        transactions == null
            ? const LinearProgressIndicator()
            : const SizedBox(
                height: 4,
              ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 8),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                "Hi ${Provider.of<GlobalHandler>(context).user?.userName.split(" ").first}",
                style: const TextStyle(
                  fontSize: 48,
                ),
              ),
              const Text("Here's your spending breakdown for this period"),
            ],
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 4,
              child: FilledButton.tonal(
                onPressed: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    initialDateRange: DateTimeRange(start: startDate, end: endDate),
                    firstDate: DateTime(1960, 1, 1),
                    lastDate: DateTime.now(),
                  );
                  if (range != null) {
                    fetchTransactions();
                    setState(() {
                      startDate = range.start;
                      endDate = range.end;
                    });
                  }
                },
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      "${DateFormat("yyyy-MM-dd").format(startDate)} to "
                      "${DateFormat("yyyy-MM-dd").format(endDate)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, child: IconButton(onPressed: () {}, icon: const Icon(Icons.settings))),
          ],
        ),
        Flexible(
          child: AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TransactionsLineChart(transactions: transactions ?? []),
            ),
            // ignore: prefer_const_constructors
            secondChild: AspectRatio(
              aspectRatio: 1.7,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: PulsatingCard(),
              ),
            ),
            crossFadeState: transactions == null ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 500),
          ),
        )
      ],
    );
  }
}
