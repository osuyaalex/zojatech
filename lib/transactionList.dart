import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: TransactionService.fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CenterWidget(widget: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return CenterWidget(widget: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const CenterWidget(widget: Text('No transactions found.'));
          } else {
            return TransactionList(transactions: snapshot.data!);
          }
        },
      ),
    );
  }
}

class CenterWidget extends StatelessWidget {
  final Widget widget;
  const CenterWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget,
    );
  }
}


class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return TransactionTile(transaction: transactions[index]);
      },
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.description),
      subtitle: Text(transaction.date),
      trailing: Text('\$${transaction.amount}'),
    );
  }
}

class TransactionService {
  static Future<List<Transaction>> fetchTransactions() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      Transaction(description: 'Groceries', date: '2024-05-01', amount: 50.0),
      Transaction(description: 'Rent', date: '2024-05-01', amount: 1000.0),
      // More transactions...
    ];
  }
}

class Transaction {
  final String description;
  final String date;
  final double amount;

  Transaction({required this.description, required this.date, required this.amount});
}