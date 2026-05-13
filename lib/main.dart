import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Nombre del alumno (splash y encabezado).
const String kAuthorFullName = 'Miguel Alejandro Chavez Gonzaga';

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
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFCC0000),
        brightness: Brightness.dark,
        surface: const Color(0xFF0A0A0A),
      ),
    );
    return MaterialApp(
      title: 'Calc Científica CETIS 131',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        splashFactory: InkSparkle.splashFactory,
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
    with TickerProviderStateMixin {
  late AnimationController _intro;
  late AnimationController _progress;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slideText;
  late Animation<double> _barValue;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic),
    );
    _slideText = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic));

    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _barValue = CurvedAnimation(parent: _progress, curve: Curves.easeInOut);

    _intro.forward();
    _progress.forward();

    _navTimer = Timer(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const CalculatorScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _intro.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final logoSize = (h * 0.22).clamp(120.0, 200.0);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212),
              Color(0xFF0A0A0A),
              Color(0xFF140808),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: math.max(
                      320.0,
                      h - MediaQuery.paddingOf(context).vertical - 48,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFCC0000).withValues(alpha: 0.85),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFCC0000).withValues(alpha: 0.35),
                              blurRadius: 32,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo_cetis.jpg',
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: logoSize,
                              height: logoSize,
                              color: const Color(0xFF222222),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.school_rounded,
                                color: Color(0xFFCC0000),
                                size: 64,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'CETIS 131',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFCC0000),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Calculadora científica',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 36),
                      SlideTransition(
                        position: _slideText,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Alumno',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.45),
                                      fontSize: 11,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    kAuthorFullName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFFE8E8E8),
                                      fontSize: 16,
                                      height: 1.35,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 200,
                        child: AnimatedBuilder(
                          animation: _barValue,
                          builder: (_, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: _barValue.value,
                              minHeight: 5,
                              backgroundColor: const Color(0xFF2A2A2A),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFCC0000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Cargando…',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

  /// Convierte un ángulo en radianes (p. ej. salida de asin) al modo DEG/RAD mostrado.
  double _fromInvTrigRad(double rad) =>
      _isDeg ? rad * 180 / math.pi : rad;

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
      _waitingForOperand = _operator.isNotEmpty;
      _hasResult = false;
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
    if (_operator.isNotEmpty && !_waitingForOperand) {
      _calculate();
    }
    setState(() {
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
        result = _fromInvTrigRad(math.asin(v));
        break;
      case 'acos':
        result = _fromInvTrigRad(math.acos(v));
        break;
      case 'atan':
        result = _fromInvTrigRad(math.atan(v));
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
      case 'asinh':
        result = math.log(v + math.sqrt(v * v + 1));
        break;
      case 'acosh':
        result = v < 1 ? double.nan : math.log(v + math.sqrt(v * v - 1));
        break;
      case 'atanh':
        result = v <= -1 || v >= 1
            ? double.nan
            : 0.5 * math.log((1 + v) / (1 - v));
        break;
      case 'log':
        result = v <= 0 ? double.nan : math.log(v) / math.ln10;
        break;
      case 'ln':
        result = v <= 0 ? double.nan : math.log(v);
        break;
      case 'log2':
        result = v <= 0 ? double.nan : math.log(v) / math.ln2;
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
        if (v < 0 || v > 170 || (v - v.roundToDouble()).abs() > 1e-9) {
          result = double.nan;
        } else {
          final f = _factorial(v.round());
          result = f < 0 ? double.nan : f.toDouble();
        }
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
    if (n < 0 || n > 20) return -1;
    int r = 1;
    for (int i = 2; i <= n; i++) {
      r *= i;
    }
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
          _hasResult = false;
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
        minimum: const EdgeInsets.only(bottom: 6),
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
          horizontal: 14, vertical: compact ? 6 : 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1F1F1F)),
        ),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/logo_cetis.jpg',
              width: compact ? 28 : 38,
              height: compact ? 28 : 38,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: compact ? 28 : 38,
                height: compact ? 28 : 38,
                color: const Color(0xFF222222),
                child: Icon(
                  Icons.school_rounded,
                  size: compact ? 16 : 20,
                  color: const Color(0xFFCC0000),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CETIS 131',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFFCC0000),
                    fontSize: compact ? 10 : 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  kAuthorFullName,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF9A9A9A),
                    fontSize: compact ? 8 : 11,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: _isDeg ? const Color(0xFFCC0000) : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => setState(() => _isDeg = !_isDeg),
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.white.withValues(alpha: 0.2),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  _isDeg ? 'DEG' : 'RAD',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
          horizontal: 18, vertical: compact ? 10 : 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF101010),
            Color(0xFF0A0A0A),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Expression
          Text(
            _expression,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.28),
              fontSize: compact ? 12 : 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // Main display
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: TextStyle(
                color: _display == 'Error' ? const Color(0xFFFF6B6B) : Colors.white,
                fontSize: compact ? 38 : 48,
                fontWeight: FontWeight.w300,
                letterSpacing: -1.5,
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
    final numberPad = Expanded(
      flex: showScientific ? 23 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildExpandedKeyRow([
            _btn('AC', _onAC, type: BtnType.fn),
            _btn('CE', _onCE, type: BtnType.fn),
            _btn('⌫', _onBack, type: BtnType.fn),
            _btn('%', _onPercent, type: BtnType.fn),
            _btn('÷', () => _onOperator('÷'), type: BtnType.op),
          ]),
          _buildExpandedKeyRow([
            _btn('7', () => _onDigit('7')),
            _btn('8', () => _onDigit('8')),
            _btn('9', () => _onDigit('9')),
            _btn('×', () => _onOperator('×'), type: BtnType.op),
          ]),
          _buildExpandedKeyRow([
            _btn('4', () => _onDigit('4')),
            _btn('5', () => _onDigit('5')),
            _btn('6', () => _onDigit('6')),
            _btn('−', () => _onOperator('−'), type: BtnType.op),
          ]),
          _buildExpandedKeyRow([
            _btn('1', () => _onDigit('1')),
            _btn('2', () => _onDigit('2')),
            _btn('3', () => _onDigit('3')),
            _btn('+', () => _onOperator('+'), type: BtnType.op),
          ]),
          _buildExpandedKeyRow([
            _btn('+/−', _onPlusMinus),
            _btn('0', () => _onDigit('0')),
            _btn('.', () => _onDigit('.')),
            _btn('=', _calculate, type: BtnType.equals),
          ]),
        ],
      ),
    );

    if (!showScientific) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [numberPad],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _scientificKeyRows(),
          ),
        ),
        numberPad,
      ],
    );
  }

  /// Filas de funciones científicas (reutilizadas en vertical y en modo horizontal).
  List<Widget> _scientificKeyRows() {
    return [
      _buildExpandedKeyRow([
        _btn(_isSecond ? 'sin⁻¹' : 'sin',
            () => _onScientific(_isSecond ? 'asin' : 'sin'), type: BtnType.sci),
        _btn(_isSecond ? 'cos⁻¹' : 'cos',
            () => _onScientific(_isSecond ? 'acos' : 'cos'), type: BtnType.sci),
        _btn(_isSecond ? 'tan⁻¹' : 'tan',
            () => _onScientific(_isSecond ? 'atan' : 'tan'), type: BtnType.sci),
        _btn(_isSecond ? 'sinh⁻¹' : 'sinh',
            () => _onScientific(_isSecond ? 'asinh' : 'sinh'), type: BtnType.sci),
        _btn(_isSecond ? 'cosh⁻¹' : 'cosh',
            () => _onScientific(_isSecond ? 'acosh' : 'cosh'), type: BtnType.sci),
      ]),
      _buildExpandedKeyRow([
        _btn(_isSecond ? '10ˣ' : 'log',
            () => _onScientific(_isSecond ? '10ˣ' : 'log'), type: BtnType.sci),
        _btn(_isSecond ? 'eˣ' : 'ln',
            () => _onScientific(_isSecond ? 'eˣ' : 'ln'), type: BtnType.sci),
        _btn(_isSecond ? '2ˣ' : 'log₂',
            () => _onScientific(_isSecond ? '2ˣ' : 'log2'), type: BtnType.sci),
        _btn(_isSecond ? 'tanh⁻¹' : 'tanh',
            () => _onScientific(_isSecond ? 'atanh' : 'tanh'), type: BtnType.sci),
        _btn('π', () => _onScientific('π'), type: BtnType.sci),
        _btn('e', () => _onScientific('e'), type: BtnType.sci),
      ]),
      _buildExpandedKeyRow([
        _btn(_isSecond ? 'x³' : 'x²',
            () => _onScientific(_isSecond ? 'x³' : 'x²'), type: BtnType.sci),
        _btn(_isSecond ? '∛' : '√',
            () => _onScientific(_isSecond ? '∛' : '√'), type: BtnType.sci),
        _btn('yˣ', () => _onOperator('yˣ'), type: BtnType.sci),
        _btn('ˣ√y', () => _onOperator('ˣ√y'), type: BtnType.sci),
        _btn('1/x', () => _onScientific('1/x'), type: BtnType.sci),
      ]),
      _buildExpandedKeyRow([
        _btn(
          '2nd',
          () => setState(() => _isSecond = !_isSecond),
          type: _isSecond ? BtnType.op : BtnType.sci,
        ),
        _btn('x!', () => _onScientific('x!'), type: BtnType.sci),
        _btn('abs', () => _onScientific('abs'), type: BtnType.sci),
        _btn('EE', () => _onOperator('EE'), type: BtnType.sci),
        _btn('Rand', () => _onScientific('Rand'), type: BtnType.sci),
      ]),
      _buildExpandedKeyRow([
        _btn('MC', () => _onMemory('MC'), type: BtnType.sci),
        _btn('MR', () => _onMemory('MR'), type: BtnType.sci),
        _btn('M+', () => _onMemory('M+'), type: BtnType.sci),
        _btn('M-', () => _onMemory('M-'), type: BtnType.sci),
        _btn('MS', () => _onMemory('MS'), type: BtnType.sci),
      ]),
    ];
  }

  Widget _buildScientificPad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _scientificKeyRows(),
    );
  }

  Widget _buildExpandedKeyRow(List<Widget> btns) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: btns.map((b) => Expanded(child: b)).toList(),
      ),
    );
  }

  Widget _btn(String label, VoidCallback onTap,
      {BtnType type = BtnType.num}) {
    Color bg;
    Color fg;
    switch (type) {
      case BtnType.fn:
        bg = const Color(0xFF3A3A3A);
        fg = Colors.white;
        break;
      case BtnType.op:
        bg = const Color(0xFFD40000);
        fg = Colors.white;
        break;
      case BtnType.equals:
        bg = const Color(0xFFD40000);
        fg = Colors.white;
        break;
      case BtnType.sci:
        bg = const Color(0xFF1E1E1E);
        fg = const Color(0xFFFF7A7A);
        break;
      case BtnType.num:
        bg = const Color(0xFF232323);
        fg = Colors.white;
        break;
    }

    final radius = BorderRadius.circular(10);
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Material(
        color: bg,
        borderRadius: radius,
        elevation: type == BtnType.equals || type == BtnType.op ? 2 : 0,
        shadowColor: const Color(0xFFCC0000).withValues(alpha: 0.4),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: radius,
          splashColor: const Color(0xFFCC0000).withValues(alpha: 0.22),
          highlightColor: Colors.white.withValues(alpha: 0.06),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: _labelFontSize(label, type),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _labelFontSize(String label, BtnType type) {
    final base = type == BtnType.sci ? 11.5 : 15.0;
    if (label.length > 6) return base - 3;
    if (label.length > 4) return base - 1.5;
    return base;
  }
}

enum BtnType { num, fn, op, equals, sci }
