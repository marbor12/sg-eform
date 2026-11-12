class Transaction {
  final String title;
  final String date;
  final String amount;
  final bool isIncome; 

  const Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });
}

const dummyTransactions = [
  Transaction(
    title: 'Remittance ke BNI Jakarta',
    date: '24 Okt · RMT-SG-2026-01177',
    amount: '− SGD 1,010.00',
    isIncome: false,
  ),
  Transaction(
    title: 'Gaji Oktober',
    date: '23 Okt · GIRO',
    amount: '+ SGD 6,800.00',
    isIncome: true,
  ),
  Transaction(
    title: 'FAST transfer keluar',
    date: '21 Okt · DBS ••91',
    amount: '− SGD 250.00',
    isIncome: false,
  ),
  Transaction(
    title: 'Biaya admin',
    date: '01 Okt',
    amount: '− SGD 2.00',
    isIncome: false,
  ),
];