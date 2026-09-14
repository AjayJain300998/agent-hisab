String toMarathi(String input) {
  if (input.trim().isEmpty) return input;
  if (RegExp(r'[\u0900-\u097F]').hasMatch(input)) return input;

  final words = input.split(RegExp(r'(\s+)'));
  return words.map(_word).join();
}

String _word(String w) {
  if (w.trim().isEmpty) return w;
  const exact = {
    'abc': 'एबीसी', 'rohit': 'रोहित', 'sagar': 'सागर',
    'amit': 'अमित', 'raj': 'राज', 'ravi': 'रवी',
    'agent': 'एजंट', 'hisab': 'हिशोब', 'dene': 'देणे', 'ghene': 'घेणे',
    'shridevi': 'श्रीदेवी', 'time': 'टाइम', 'milan': 'मिलन',
    'day': 'डे', 'kalyan': 'कल्याण', 'night': 'नाईट', 'main': 'मेन', 'bazar': 'बाजार',
  };
  final low = w.toLowerCase();
  if (exact.containsKey(low)) return exact[low]!;

  // Small offline phonetic transliterator for ordinary agent names.
  final tokens = RegExp(r'(ksh|chh|jh|th|dh|ph|bh|gh|kh|sh|ch|aa|ii|ee|oo|ai|au|[bcdfgjklmnpqrstvwxyz]|[aeiou])', caseSensitive: false)
      .allMatches(low).map((m) => m.group(0)!.toLowerCase()).toList();
  const c = {
    'k':'क','kh':'ख','g':'ग','gh':'घ','ng':'ङ','ch':'च','chh':'छ','j':'ज','jh':'झ',
    't':'त','th':'थ','d':'द','dh':'ध','n':'न','p':'प','ph':'फ','b':'ब','bh':'भ',
    'm':'म','y':'य','r':'र','l':'ल','v':'व','w':'व','s':'स','sh':'श','h':'ह',
    'q':'क','x':'क्स','z':'झ','f':'फ',
  };
  const v = {'a':'अ','aa':'आ','i':'इ','ii':'ई','ee':'ई','u':'उ','oo':'ऊ','e':'ए','ai':'ऐ','o':'ओ','au':'औ'};
  const matra = {'a':'','aa':'ा','i':'ि','ii':'ी','ee':'ी','u':'ु','oo':'ू','e':'े','ai':'ै','o':'ो','au':'ौ'};
  var out = '';
  for (var i=0; i<tokens.length; i++) {
    final t = tokens[i];
    if (v.containsKey(t)) {
      out += v[t]!;
    } else if (c.containsKey(t)) {
      var next = i + 1 < tokens.length ? tokens[i+1] : '';
      if (matra.containsKey(next)) {
        out += c[t]! + matra[next]!;
        i++;
      } else {
        out += c[t]! + '्';
      }
    }
  }
  return out.replaceAll('् ', ' ').replaceAll(RegExp(r'्$'), '');
}
