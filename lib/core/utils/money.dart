String formatMoney(double value, {int decimals = 2}) {
  final parts = value.toStringAsFixed(decimals).split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
  return decimals == 0 ? whole : '$whole.${parts[1]}';
}