import 'package:flutter/material.dart';
import '../../../../../settle_iapi.dart';

class TransactionTabs extends StatefulWidget {
  const TransactionTabs({
    Key? key,
  }) : super(key: key);

  @override
  State<TransactionTabs> createState() => _TransactionTabsState();
}

class _TransactionTabsState extends State<TransactionTabs> {
  late List<dynamic> transactions = [];
  void initState() {
    super.initState();
    allTransactions();
  }

  Future<void> allTransactions() async {
    // await Future.delayed(Duration(seconds: 10));
    print('Fetching Transactions...........');

    try {
      var siapi = SettleIAPI();

      List<dynamic> fetchedTransactions = await siapi.fetchTransactions({});

      setState(() {
        transactions = fetchedTransactions;
      });

      print('\n*******TRANSACTIONS*******');
      print('DATE | AMOUNT | RECEIVER | TRANSACTION_ID');

      if (transactions.length > 0) {
        transactions.forEach((transaction) {
          print(
              '${transaction['date']} | ${transaction['amount']} | ${transaction['receiver']} | ${transaction['id']}');
        });
      } else {
        print(' - No transactions found.');
        // Handle the case when no transactions are found, e.g., display a message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No transactions found.'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          elevation: 10,
        ));
      }

      // hide Activity indicator
      print('\nDone');
    } on NetworkErrorException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Network error occurred. Please check your internet connection.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    } on InvalidResponseException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Server error. Try again later.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    } on ServerErrorException catch (e, s) {
      print('Server error stack trace: $s');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Server error. Try again later.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    } on UnauthorizedRequestException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Unauthorized request. Please log in.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));

      // Handle unauthorized request, e.g., navigate to the login screen
    } catch (e, s) {
      print('An unknown error occurred. Stack trace: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An unknown error occurred.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 10,
      ));
    }
  }

  Future<void> _handleRefresh() async {
    // Perform your refresh logic here
    await allTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          transactions.isEmpty ||
                  transactions.every((transaction) => transaction.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Image.asset(
                        'assets/images/no_transactions_found.png',
                        height: 150, // adjust the height as needed
                        width: 150, // adjust the width as needed
                        // You can also use other properties of Image.asset, such as fit, alignment, etc.
                      ),
                      SizedBox(
                        height:
                            20, // adjust the height for spacing between image and text
                      ),
                      Text('No transactions found.'),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return ListTile(
                      title: Text(
                        '${transaction['date']} | ${transaction['amount']} | ${transaction['receiver']} | ${transaction['id']}',
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}
