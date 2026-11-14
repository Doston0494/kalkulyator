import 'package:flutter/material.dart';
import 'models/kalkulyator.dart';
import 'screens/tarix_ekran.dart';

void main() {
  runApp(const KalkulyatorApp());
}

class KalkulyatorApp extends StatefulWidget {
  const KalkulyatorApp({super.key});

  @override
  State<KalkulyatorApp> createState() => _KalkulyatorAppState();
}

class _KalkulyatorAppState extends State<KalkulyatorApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _mavzuAlmashtir() {
    setState(() {
      _themeMode =
          (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulyator',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: KalkulyatorEkran(
        themeMode: _themeMode,
        onMavzuAlmashtir: _mavzuAlmashtir,
      ),
    );
  }
}

class KalkulyatorEkran extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onMavzuAlmashtir;

  const KalkulyatorEkran({
    super.key,
    required this.themeMode,
    required this.onMavzuAlmashtir,
  });

  @override
  State<KalkulyatorEkran> createState() => _KalkulyatorEkranState();
}

class _KalkulyatorEkranState extends State<KalkulyatorEkran> {
  final Kalkulyator _calc = Kalkulyator();

  final List<List<String>> _vertikalTugmalar = const [
    ['√x', 'x²', '1/x', '÷'],
    ['C', '⌫', '%', '×'],
    ['7', '8', '9', '-'],
    ['4', '5', '6', '+'],
    ['1', '2', '3', '='],
    ['±', '0', '.', ''],
  ];

  final List<List<String>> _gorizontalTugmalar = const [
    ['√x', '7', '8', '9', '÷', 'C'],
    ['x²', '4', '5', '6', '×', '⌫'],
    ['1/x', '1', '2', '3', '-', '%'],
    ['±', '0', '.', '=', '+', ''],
  ];

  void _bosildi(String t) {
    if (t.isEmpty) return;
    setState(() {
      switch (t) {
        case 'C':
          _calc.tozala();
          break;
        case '⌫':
          _calc.ochir();
          break;
        case '%':
          _calc.foiz();
          break;
        case '±':
          _calc.ishora();
          break;
        case '√x':
          _calc.ildiz();
          break;
        case 'x²':
          _calc.kvadrat();
          break;
        case '1/x':
          _calc.teskari();
          break;
        case '=':
          _calc.hisobla();
          break;
        case '+':
        case '-':
        case '×':
        case '÷':
          _calc.amalBos(t);
          break;
        default:
          _calc.raqamBos(t);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rang = Theme.of(context).colorScheme;
    final isDark = widget.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulyator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Tarix',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TarixEkran(
                    tarix: _calc.tarixRoyxati,
                    onTozalash: () => setState(() => _calc.tarixRoyxati.clear()),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Mavzuni o\'zgartirish',
            onPressed: widget.onMavzuAlmashtir,
          ),
        ],
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;
            final tugmalar =
                isPortrait ? _vertikalTugmalar : _gorizontalTugmalar;

            if (isPortrait) {
              return Column(
                children: [
                  Expanded(flex: 2, child: _ekranQismi(rang)),
                  Expanded(flex: 5, child: _tugmalarPaneli(tugmalar, rang, true)),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(flex: 2, child: _ekranQismi(rang)),
                  Expanded(flex: 3, child: _tugmalarPaneli(tugmalar, rang, false)),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _ekranQismi(ColorScheme rang) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _calc.tarix,
            style: TextStyle(fontSize: 20, color: rang.outline),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _calc.ekran,
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tugmalarPaneli(
      List<List<String>> tugmalar, ColorScheme rang, bool isPortrait) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: tugmalar.map((qator) {
          return Expanded(
            child: Row(
              children: qator
                  .map((t) => _tugma(t, rang, isPortrait))
                  .toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _tugma(String matn, ColorScheme rang, bool isPortrait) {
    if (matn.isEmpty) {
      return const Expanded(child: SizedBox());
    }

    final amalmi = ['+', '-', '×', '÷', '='].contains(matn);
    final maxsusmi = ['C', '⌫', '%', '±', '√x', 'x²', '1/x'].contains(matn);

    Color fon;
    Color yozuv;

    if (amalmi) {
      fon = rang.primary;
      yozuv = rang.onPrimary;
    } else if (maxsusmi) {
      fon = rang.secondaryContainer;
      yozuv = rang.onSecondaryContainer;
    } else {
      fon = rang.surfaceContainerHighest;
      yozuv = rang.onSurface;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox.expand(
          child: ElevatedButton(
            onPressed: () => _bosildi(matn),
            style: ElevatedButton.styleFrom(
              backgroundColor: fon,
              foregroundColor: yozuv,
              shape: isPortrait
                  ? const StadiumBorder()
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              matn,
              style: TextStyle(fontSize: isPortrait ? 22 : 18),
            ),
          ),
        ),
      ),
    );
  }
}
