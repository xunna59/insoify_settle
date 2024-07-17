class Transaction {
  final String id;
  final double amount;
  final String receiver;
  final String date;
  final String status;
  final String bank;
  final String destination;

  Transaction({
    required this.id,
    required this.amount,
    required this.receiver,
    required this.date,
    required this.status,
    required this.bank,
    required this.destination,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      amount: double.parse(json['amount'].toString()),
      receiver: json['receiver'].toString(),
      date: json['Date'].toString(),
      status: json['Status'].toString(),
      bank: json['Bank'].toString(),
      destination: json['destination'].toString(),
    );
  }
}
