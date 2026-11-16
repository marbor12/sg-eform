class Transaction {
  final String title;
  final String date;
  final String amount;
  final bool isIncome; // true = uang masuk, false = uang keluar

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

class MutasiItem {
  final String? day;
  final String title;
  final String desc;
  final String amount;
  final bool isIncome;

  const MutasiItem({
    this.day,
    required this.title,
    required this.desc,
    required this.amount,
    required this.isIncome,
  });
}

const dummyMutasi = [
  MutasiItem(
    day: '24 Okt 2026',
    title: 'Remittance ke Indonesia',
    desc: 'RMT-SG-2026-01177 · Go Remit',
    amount: '- 1,000.00',
    isIncome: false,
  ),
  MutasiItem(
    title: 'Biaya remittance',
    desc: 'RMT-SG-2026-01177',
    amount: '- 10.00',
    isIncome: false,
  ),
  MutasiItem(
    day: '23 Okt 2026',
    title: 'Gaji Oktober',
    desc: 'GIRO credit',
    amount: '+ 6,800.00',
    isIncome: true,
  ),
  MutasiItem(
    day: '21 Okt 2026',
    title: 'FAST transfer keluar',
    desc: 'DBS ••91 · sewa',
    amount: '- 250.00',
    isIncome: false,
  ),
  MutasiItem(
    title: 'PayNow keluar',
    desc: '+65 8••• ••07',
    amount: '- 87.20',
    isIncome: false,
  ),
  MutasiItem(
    day: '20 Okt 2026',
    title: 'NETS purchase',
    desc: 'FairPrice',
    amount: '- 2.00',
    isIncome: false,
  ),
];
