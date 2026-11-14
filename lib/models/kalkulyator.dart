import 'dart:math';

class Kalkulyator {
  double? _birinchiSon;
  String? _amal;
  String ekran = '0';
  String tarix = '';
  bool _yangiSonKiritish = false;

  // Barcha bajarilgan amallar tarixi
  final List<String> tarixRoyxati = [];

  void raqamBos(String raqam) {
    if (_yangiSonKiritish) {
      ekran = '0';
      _yangiSonKiritish = false;
    }
    if (raqam == '.') {
      if (ekran.contains('.')) return;
      ekran += '.';
      return;
    }
    ekran = (ekran == '0') ? raqam : ekran + raqam;
  }

  void amalBos(String amal) {
    if (_amal != null && !_yangiSonKiritish) {
      hisobla();
    }
    _birinchiSon = double.tryParse(ekran);
    _amal = amal;
    tarix = '${_formatla(_birinchiSon!)} $amal';
    _yangiSonKiritish = true;
  }

  void hisobla() {
    if (_birinchiSon == null || _amal == null) return;
    final ikkinchiSon = double.tryParse(ekran) ?? 0;
    double natija;

    switch (_amal) {
      case '+':
        natija = _birinchiSon! + ikkinchiSon;
        break;
      case '-':
        natija = _birinchiSon! - ikkinchiSon;
        break;
      case '×':
        natija = _birinchiSon! * ikkinchiSon;
        break;
      case '÷':
        if (ikkinchiSon == 0) {
          ekran = 'Xato: 0 ga bo\'lish';
          tarix = '';
          _tozalashIchki();
          return;
        }
        natija = _birinchiSon! / ikkinchiSon;
        break;
      default:
        return;
    }

    final ifoda = '${_formatla(_birinchiSon!)} $_amal ${_formatla(ikkinchiSon)}';
    final formatlanganNatija = _formatla(natija);

    tarix = '$ifoda =';
    ekran = formatlanganNatija;
    tarixRoyxati.insert(0, '$ifoda = $formatlanganNatija');

    _birinchiSon = null;
    _amal = null;
    _yangiSonKiritish = true;
  }

  // Ilmiy funksiyalar (√x, x², 1/x)
  void ildiz() {
    final son = double.tryParse(ekran);
    if (son == null) return;
    if (son < 0) {
      ekran = 'Xato: manfiy ildiz';
      tarix = '';
      _tozalashIchki();
      return;
    }
    final natija = _formatla(sqrt(son));
    tarix = '√(${_formatla(son)})';
    ekran = natija;
    tarixRoyxati.insert(0, '$tarix = $natija');
    _yangiSonKiritish = true;
  }

  void kvadrat() {
    final son = double.tryParse(ekran);
    if (son == null) return;
    final natija = _formatla(pow(son, 2).toDouble());
    tarix = '(${_formatla(son)})²';
    ekran = natija;
    tarixRoyxati.insert(0, '$tarix = $natija');
    _yangiSonKiritish = true;
  }

  void teskari() {
    final son = double.tryParse(ekran);
    if (son == null) return;
    if (son == 0) {
      ekran = 'Xato: 0 ga bo\'lish';
      tarix = '';
      _tozalashIchki();
      return;
    }
    final natija = _formatla(1 / son);
    tarix = '1/(${_formatla(son)})';
    ekran = natija;
    tarixRoyxati.insert(0, '$tarix = $natija');
    _yangiSonKiritish = true;
  }

  void tozala() {
    ekran = '0';
    tarix = '';
    _tozalashIchki();
  }

  void ochir() {
    if (_yangiSonKiritish) return;
    ekran = (ekran.length > 1) ? ekran.substring(0, ekran.length - 1) : '0';
  }

  void ishora() {
    if (ekran == '0' || ekran.startsWith('Xato')) return;
    ekran = ekran.startsWith('-') ? ekran.substring(1) : '-$ekran';
  }

  void foiz() {
    final son = double.tryParse(ekran);
    if (son == null) return;
    ekran = _formatla(son / 100);
  }

  void _tozalashIchki() {
    _birinchiSon = null;
    _amal = null;
    _yangiSonKiritish = true;
  }

  String _formatla(double son) {
    if (son == son.truncateToDouble()) return son.toInt().toString();
    return double.parse(son.toStringAsFixed(8)).toString();
  }
}
