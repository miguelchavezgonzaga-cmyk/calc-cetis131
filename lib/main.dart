import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const CalcApp());
}

class CalcApp extends StatelessWidget {
  const CalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calc Científica CETIS 131',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: const SplashScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.75, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => const CalculatorScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo con sombra roja tipo CETIS
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCC0000).withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo_cetis.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'CETIS 131',
                  style: TextStyle(
                    color: Color(0xFFCC0000),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Calculadora Científica',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 48),
                const Divider(
                    color: Color(0xFF333333), indent: 60, endIndent: 60),
                const SizedBox(height: 24),
                const Text(
                  'Miguel Alejandro Chavez Gonzaga',
                  style: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 140,
                  child: LinearProgressIndicator(
                    backgroundColor: const Color(0xFF222222),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFCC0000)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CALCULADORA CIENTÍFICA
// ─────────────────────────────────────────────
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  double _secondOperand = 0;
  String _operator = '';
  bool _waitingForOperand = false;
  bool _isDeg = true; // true=DEG, false=RAD
  bool _isSecond = false; // 2nd functions toggle
  String _memory = '0';
  bool _hasResult = false;

  // ── helpers ──────────────────────────────────
  double get _currentValue => double.tryParse(_display) ?? 0;

  double _toRad(double v) => _isDeg ? v * math.pi / 180 : v;
  double _toDeg(double v) => _isDeg ? v : v * 180 / math.pi;

  void _updateDisplay(String val) {
    if (val.length > 15) val = val.substring(0, 15);
    setState(() => _display = val);
  }

  String _formatResult(double v) {
    if (v.isNaN) return 'Error';
    if (v.isInfinite) return v > 0 ? '∞' : '-∞';
    if (v == v.truncateToDouble() && v.abs() < 1e15) {
      return v.toInt().toString();
    }
    String s = v.toStringAsPrecision(10);
    // Remove trailing zeros after decimal
    if (s.contains('.') && !s.contains('e')) {
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }

  // ── number input ──────────────────────────────
  void _onDigit(String d) {
    setState(() {
      if (_hasResult) {
        _display = d == '.' ? '0.' : d;
        _expression = '';
        _hasResult = false;
      } else if (_waitingForOperand) {
        _display = d == '.' ? '0.' : d;
        _waitingForOperand = false;
      } else {
        if (d == '.' && _display.contains('.')) return;
        _display = _display == '0' && d != '.' ? d : _display + d;
      }
    });
  }

  // ── clear ─────────────────────────────────────
  void _onAC() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = 0;
      _operator = '';
      _waitingForOperand = false;
      _hasResult = false;
    });
  }

  void _onCE() {
    setState(() {
      _display = '0';
      _waitingForOperand = false;
    });
  }

  // ── plus/minus ────────────────────────────────
  void _onPlusMinus() {
    final v = _currentValue * -1;
    _updateDisplay(_formatResult(v));
  }

  // ── percent ───────────────────────────────────
  void _onPercent() {
    double v = _currentValue;
    if (_operator.isNotEmpty) {
      v = _firstOperand * v / 100;
    } else {
      v = v / 100;
    }
    _updateDisplay(_formatResult(v));
  }

  // ── binary operator ───────────────────────────
  void _onOperator(String op) {
    setState(() {
      if (_operator.isNotEmpty && !_waitingForOperand) {
        _calculate();
      }
      _firstOperand = _currentValue;
      _operator = op;
      _waitingForOperand = true;
      _hasResult = false;
      _expression = '${_formatResult(_firstOperand)} $op';
    });
  }

  void _calculate() {
    if (_operator.isEmpty) return;
    _secondOperand = _currentValue;
    double result;
    switch (_operator) {
      case '+':
        result = _firstOperand + _secondOperand;
        break;
      case '−':
        result = _firstOperand - _secondOperand;
        break;
      case '×':
        result = _firstOperand * _secondOperand;
        break;
      case '÷':
        result =
            _secondOperand == 0 ? double.nan : _firstOperand / _secondOperand;
        break;
      case 'yˣ':
        result = math.pow(_firstOperand, _secondOperand).toDouble();
        break;
      case 'ˣ√y':
        result = math.pow(_secondOperand, 1 / _firstOperand).toDouble();
        break;
      case 'EE':
        result = _firstOperand * math.pow(10, _secondOperand).toDouble();
        break;
      default:
        result = _secondOperand;
    }
    setState(() {
      _expression =
          '${_formatResult(_firstOperand)} $_operator ${_formatResult(_secondOperand)} =';
      _display = _formatResult(result);
      _operator = '';
      _firstOperand = result;
      _waitingForOperand = true;
      _hasResult = true;
    });
  }

  // ── scientific functions ──────────────────────
  void _onScientific(String fn) {
    double v = _currentValue;
    double result;
    switch (fn) {
      case 'sin':
        result = math.sin(_toRad(v));
        break;
      case 'cos':
        result = math.cos(_toRad(v));
        break;
      case 'tan':
        result = math.tan(_toRad(v));
        break;
      case 'asin':
        result = _toDeg(math.asin(v));
        break;
      case 'acos':
        result = _toDeg(math.acos(v));
        break;
      case 'atan':
        result = _toDeg(math.atan(v));
        break;
      case 'sinh':
        result = (math.exp(v) - math.exp(-v)) / 2;
        break;
      case 'cosh':
        result = (math.exp(v) + math.exp(-v)) / 2;
        break;
      case 'tanh':
        final e2x = math.exp(2 * v);
        result = (e2x - 1) / (e2x + 1);
        break;
      case 'log':
        result = v <= 0 ? double.nan : math.log(v) / math.ln10;
        break;
      case 'ln':
        result = v <= 0 ? double.nan : math.log(v);
        break;
      case 'log2':
        result = v <= 0 ? double.nan : math.log(v) / math.log2e / math.log2e;
        // correct:
        result = v <= 0 ? double.nan : math.log(v) / math.log(2);
        break;
      case '10ˣ':
        result = math.pow(10, v).toDouble();
        break;
      case 'eˣ':
        result = math.exp(v);
        break;
      case '2ˣ':
        result = math.pow(2, v).toDouble();
        break;
      case 'x²':
        result = v * v;
        break;
      case 'x³':
        result = v * v * v;
        break;
      case '√':
        result = v < 0 ? double.nan : math.sqrt(v);
        break;
      case '∛':
        result = math.pow(v.abs(), 1 / 3).toDouble() * (v < 0 ? -1 : 1);
        break;
      case '1/x':
        result = v == 0 ? double.nan : 1 / v;
        break;
      case 'x!':
        result = _factorial(v.toInt()).toDouble();
        break;
      case 'π':
        result = math.pi;
        break;
      case 'e':
        result = math.e;
        break;
      case 'Rand':
        result = math.Random().nextDouble();
        break;
      case 'abs':
        result = v.abs();
        break;
      default:
        result = v;
    }
    setState(() {
      _display = _formatResult(result);
      _hasResult = true;
      _waitingForOperand = true;
    });
  }

  int _factorial(int n) {
    if (n < 0) return -1;
    if (n > 20) return -1; // overflow guard
    int r = 1;
    for (int i = 2; i <= n; i++) r *= i;
    return r;
  }

  // ── memory ────────────────────────────────────
  void _onMemory(String cmd) {
    setState(() {
      switch (cmd) {
        case 'MC':
          _memory = '0';
          break;
        case 'MR':
          _display = _memory;
          _waitingForOperand = false;
          break;
        case 'M+':
          _memory = _formatResult(
              (double.tryParse(_memory) ?? 0) + _currentValue);
          break;
        case 'M-':
          _memory = _formatResult(
              (double.tryParse(_memory) ?? 0) - _currentValue);
          break;
        case 'MS':
          _memory = _display;
          break;
      }
    });
  }

  // ── backspace ─────────────────────────────────
  void _onBack() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  // ── UI ────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isLandscape ? _buildLandscape() : _buildPortrait(),
      ),
    );
  }

  Widget _buildPortrait() {
    return Column(
      children: [
        _buildHeader(),
        _buildDisplayPanel(),
        const Divider(color: Color(0xFF1A1A1A), height: 1),
        Expanded(child: _buildPortraitKeypad()),
      ],
    );
  }

  Widget _buildLandscape() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildHeader(compact: true),
              _buildDisplayPanel(compact: true),
              Expanded(child: _buildScientificPad()),
            ],
          ),
        ),
        Container(width: 1, color: const Color(0xFF1A1A1A)),
        Expanded(
          flex: 3,
          child: _buildPortraitKeypad(showScientific: false),
        ),
      ],
    );
  }

  Widget _buildHeader({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 16, vertical: compact ? 6 : 10),
      color: const Color(0xFF0A0A0A),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/logo_cetis.jpg',
              width: compact ? 28 : 36,
              height: compact ? 28 : 36,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CETIS 131',
                style: TextStyle(
                  color: const Color(0xFFCC0000),
                  fontSize: compact ? 10 : 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Miguel A. Chavez Gonzaga',
                style: TextStyle(
                  color: const Color(0xFF888888),
                  fontSize: compact ? 8 : 9,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          // DEG/RAD toggle
          GestureDetector(
            onTap: () => setState(() => _isDeg = !_isDeg),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _isDeg
                    ? const Color(0xFFCC0000)
                    : const Color(0xFF222222),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _isDeg ? 'DEG' : 'RAD',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayPanel({bool compact = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 20, vertical: compact ? 12 : 20),
      color: const Color(0xFF0A0A0A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Expression
          Text(
            _expression,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Main display
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 44 : 64,
                fontWeight: FontWeight.w200,
                letterSpacing: -2,
              ),
            ),
          ),
          // Memory indicator
          if (_memory != '0')
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'M: $_memory',
                  style: const TextStyle(
                      color: Color(0xFF888888), fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPortraitKeypad({bool showScientific = true}) {
    return Column(
      children: [
        // Scientific rows (portrait only)
        if (showScientific) ...[
          _buildScientificRow1(),
          _buildScientificRow2(),
          _buildScientificRow3(),
          _buildScientificRow4(),
          _buildMemoryRow(),
        ],
        // Standard rows
        Expanded(
          child: Column(
            children: [
              _buildRow([
                _btn('AC', _onAC, type: BtnType.fn),
                _btn(_display == '0' ? 'AC' : '⌫', () {
                  if (_display != '0') _onBack();
                  else _onAC();
                }, type: BtnType.fn),
                _btn('%', _onPercent, type: BtnType.fn),
                _btn('÷', () => _onOperator('÷'), type: BtnType.op),
              ]),
              _buildRow([
                _btn('7', () => _onDigit('7')),
                _btn('8', () => _onDigit('8')),
                _btn('9', () => _onDigit('9')),
                _btn('×', () => _onOperator('×'), type: BtnType.op),
              ]),
              _buildRow([
                _btn('4', () => _onDigit('4')),
                _btn('5', () => _onDigit('5')),
                _btn('6', () => _onDigit('6')),
                _btn('−', () => _onOperator('−'), type: BtnType.op),
              ]),
              _buildRow([
                _btn('1', () => _onDigit('1')),
                _btn('2', () => _onDigit('2')),
                _btn('3', () => _onDigit('3')),
                _btn('+', () => _onOperator('+'), type: BtnType.op),
              ]),
              _buildRow([
                _btn('+/−', _onPlusMinus),
                _btn('0', () => _onDigit('0')),
                _btn('.', () => _onDigit('.')),
                _btn('=', _calculate, type: BtnType.equals),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScientificRow1() {
    return _buildRow([
      _btn(_isSecond ? 'sin⁻¹' : 'sin',
          () => _onScientific(_isSecond ? 'asin' : 'sin'), type: BtnType.sci),
      _btn(_isSecond ? 'cos⁻¹' : 'cos',
          () => _onScientific(_isSecond ? 'acos' : 'cos'), type: BtnType.sci),
      _btn(_isSecond ? 'tan⁻¹' : 'tan',
          () => _onScientific(_isSecond ? 'atan' : 'tan'), type: BtnType.sci),
      _btn(_isSecond ? 'sinh' : 'sinh',
          () => _onScientific('sinh'), type: BtnType.sci),
      _btn(_isSecond ? 'cosh' : 'cosh',
          () => _onScientific('cosh'), type: BtnType.sci),
    ]);
  }

  Widget _buildScientificRow2() {
    return _buildRow([
      _btn(_isSecond ? '10ˣ' : 'log',
          () => _onScientific(_isSecond ? '10ˣ' : 'log'), type: BtnType.sci),
      _btn(_isSecond ? 'eˣ' : 'ln',
          () => _onScientific(_isSecond ? 'eˣ' : 'ln'), type: BtnType.sci),
      _btn(_isSecond ? '2ˣ' : 'log₂',
          () => _onScientific(_isSecond ? '2ˣ' : 'log2'), type: BtnType.sci),
      _btn('π', () => _onScientific('π'), type: BtnType.sci),
      _btn('e', () => _onScientific('e'), type: BtnType.sci),
    ]);
  }

  Widget _buildScientificRow3() {
    return _buildRow([
      _btn(_isSecond ? 'x³' : 'x²',
          () => _onScientific(_isSecond ? 'x³' : 'x²'), type: BtnType.sci),
      _btn(_isSecond ? '∛' : '√',
          () => _onScientific(_isSecond ? '∛' : '√'), type: BtnType.sci),
      _btn('yˣ', () => _onOperator('yˣ'), type: BtnType.sci),
      _btn('ˣ√y', () => _onOperator('ˣ√y'), type: BtnType.sci),
      _btn('1/x', () => _onScientific('1/x'), type: BtnType.sci),
    ]);
  }

  Widget _buildScientificRow4() {
    return _buildRow([
      _btn(
        '2nd',
        () => setState(() => _isSecond = !_isSecond),
        type: _isSecond ? BtnType.op : BtnType.sci,
      ),
      _btn('x!', () => _onScientific('x!'), type: BtnType.sci),
      _btn('abs', () => _onScientific('abs'), type: BtnType.sci),
      _btn('EE', () => _onOperator('EE'), type: BtnType.sci),
      _btn('Rand', () => _onScientific('Rand'), type: BtnType.sci),
    ]);
  }

  Widget _buildMemoryRow() {
    return _buildRow([
      _btn('MC', () => _onMemory('MC'), type: BtnType.sci),
      _btn('MR', () => _onMemory('MR'), type: BtnType.sci),
      _btn('M+', () => _onMemory('M+'), type: BtnType.sci),
      _btn('M-', () => _onMemory('M-'), type: BtnType.sci),
      _btn('MS', () => _onMemory('MS'), type: BtnType.sci),
    ]);
  }

  Widget _buildScientificPad() {
    return Column(
      children: [
        _buildScientificRow1(),
        _buildScientificRow2(),
        _buildScientificRow3(),
        _buildScientificRow4(),
        _buildMemoryRow(),
      ],
    );
  }

  Widget _buildRow(List<Widget> btns) {
    return Expanded(
      child: Row(
          children: btns.map((b) => Expanded(child: b)).toList()),
    );
  }

  Widget _btn(String label, VoidCallback onTap,
      {BtnType type = BtnType.num}) {
    Color bg;
    Color fg;
    switch (type) {
      case BtnType.fn:
        bg = const Color(0xFF333333);
        fg = Colors.white;
        break;
      case BtnType.op:
        bg = const Color(0xFFCC0000);
        fg = Colors.white;
        break;
      case BtnType.equals:
        bg = const Color(0xFFCC0000);
        fg = Colors.white;
        break;
      case BtnType.sci:
        bg = const Color(0xFF1C1C1C);
        fg = const Color(0xFFFF6666);
        break;
      case BtnType.num:
        bg = const Color(0xFF1C1C1C);
        fg = Colors.white;
        break;
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          boxShadow: type == BtnType.equals || type == BtnType.op
              ? [
                  BoxShadow(
                    color: const Color(0xFFCC0000).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: _labelFontSize(label),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  double _labelFontSize(String label) {
    if (label.length > 5) return 11;
    if (label.length > 3) return 13;
    return 16;
  }
}

enum BtnType { num, fn, op, equals, sci }
