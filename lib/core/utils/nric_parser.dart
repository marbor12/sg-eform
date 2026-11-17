class NricData {
  final String? name;
  final String? nric;
  final String? dob; // format dd/MM/yyyy

  const NricData({this.name, this.nric, this.dob});

  /// berapa dari 3 data yang berhasil dibaca
  int get foundCount =>
      [name, nric, dob].where((e) => e != null && e.isNotEmpty).length;
}

// kata-kata cetakan di kartu yang bukan nama orang
final _banned = RegExp(
  r'REPUBLIC|SINGAPORE|IDENTITY|CARD|BIRTH|COUNTRY|PLACE|DATE|RACE|SEX|NAME|'
  r'CITIZEN|RESIDENT|PERMANENT|NRIC|FIN|CHINESE|MALAY|INDIAN|EURASIAN|OTHERS',
);

// OCR sering menukar huruf dan angka yang mirip
String _fixDigits(String s) {
  const map = {
    'O': '0',
    'I': '1',
    'L': '1',
    'S': '5',
    'B': '8',
    'G': '6',
    'Z': '2',
  };
  return s.split('').map((c) => map[c] ?? c).join();
}

NricData parseNric(String text) {
  final lines = text
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  // ---- NRIC / FIN: per baris, spasi dan tanda baca dibuang dulu ----
  String? nric;
  final nricRe = RegExp(r'[STFGM][0-9OILSBGZ]{7}[A-Z]');
  for (final l in lines) {
    final compact = l.toUpperCase().replaceAll(RegExp(r'[\s\-.:]'), '');
    final m = nricRe.firstMatch(compact);
    if (m == null) continue;
    final g = m.group(0)!;
    final cand = g[0] + _fixDigits(g.substring(1, 8)) + g[8];
    if (RegExp(r'^[STFGM]\d{7}[A-Z]$').hasMatch(cand)) {
      nric = cand;
      break;
    }
  }

  // ---- tanggal lahir: 14-03-1990, 14/03/1990, 14.03.1990 ----
  final d = RegExp(r'\b(\d{2})[-/.](\d{2})[-/.](\d{4})\b').firstMatch(text);
  final dob = d == null ? null : '${d.group(1)}/${d.group(2)}/${d.group(3)}';

  // ---- nama: lewat label "Name" (dengan salah-baca "Narne"/"Nama") ----
  String? name;
  final label = RegExp(r'^(name|narne|nama)\s*:?\s*(.*)$', caseSensitive: false);
  for (var i = 0; i < lines.length; i++) {
    final m = label.firstMatch(lines[i]);
    if (m == null) continue;
    final rest = m.group(2)!.trim();
    if (rest.isNotEmpty) {
      name = rest;
    } else if (i + 1 < lines.length) {
      name = lines[i + 1];
    }
    break;
  }

  // cadangan: baris huruf kapital dengan minimal 2 kata yang bukan kata cetakan
  if (name == null || _banned.hasMatch(name.toUpperCase())) {
    name = null;
    final nameRe = RegExp(r"^[A-Z][A-Z\s'./-]{4,}$");
    for (final l in lines) {
      final u = l.toUpperCase();
      if (nameRe.hasMatch(u) &&
          u.split(RegExp(r'\s+')).length >= 2 &&
          !_banned.hasMatch(u)) {
        name = u;
        break;
      }
    }
  }

  return NricData(name: name?.toUpperCase(), nric: nric, dob: dob);
}