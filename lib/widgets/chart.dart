import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_app/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:second_app/widgets/bar.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransaction {
    return List.generate(7, (index) {
      var weekDay =  DateTime.now().subtract(Duration(days: index));
      double total = 0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
         recentTransactions[i].date.month == weekDay.month && 
         recentTransactions[i].date.year == weekDay.year
        ) {
          total += recentTransactions[i].amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay).substring(0, 1), 'amount': total};
    });
  }

  double get maxSpending {
    return groupedTransaction.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.green,
        elevation: 1,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: groupedTransaction.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  (data['day'] as String), 
                  (data['amount'] as double), 
                  maxSpending == 0.0 ? 0.0 : (data['amount'] as double) / maxSpending),
              );
            }).toList()
          ),
        )
      ),
    );
  }
}