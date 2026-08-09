import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/utils/constants.dart';

/// A single highlighted line of "code" to type out in the fake terminal.
class _CodeLine {
  const _CodeLine(this.spans);
  final List<_Span> spans;

  String get fullText => spans.map((s) => s.text).join();
}

class _Span {
  const _Span(this.text, this.color);
  final String text;
  final Color color;
}

// Simple syntax-style palette
const _kType = Color(0xFF4EC9B0); // teal - values
const _kString = Color(0xFFCE9178); // orange - quoted strings
const _kComment = Color(0xFF6A9955); // green - comments / prompt
const _kPlain = Color(0xFFD4D4D4); // light grey - default text
const _kFunc = Color(0xFFDCDCAA); // yellow - commands

final List<_CodeLine> _codeLines = [
  const _CodeLine([
    _Span('?@surya-tej', _kComment),
    _Span(':~\$ ', _kPlain),
    _Span('whoami', _kFunc),
  ]),
  const _CodeLine([
    _Span('Surya Tej', _kType),
    _Span(' — Java Backend & Flutter Developer', _kPlain),
  ]),
  const _CodeLine([_Span('', _kPlain)]),
  const _CodeLine([
    _Span('?@surya-tej', _kComment),
    _Span(':~\$ ', _kPlain),
    _Span('cat ', _kFunc),
    _Span('stack.txt', _kString),
  ]),
  const _CodeLine([
    _Span('Java · Flutter · Python', _kPlain),
  ]),
  const _CodeLine([_Span('', _kPlain)]),
  const _CodeLine([
    _Span('?@surya-tej', _kComment),
    _Span(':~\$ ', _kPlain),
    _Span('cat ', _kFunc),
    _Span('traits.txt', _kString),
  ]),
  const _CodeLine([
    _Span('Team player · Patient · Adaptable', _kPlain),
  ]),
  const _CodeLine([
    _Span('Always learning something new', _kPlain),
  ]),
  const _CodeLine([_Span('', _kPlain)]),
  const _CodeLine([
    _Span('?@surya-tej', _kComment),
    _Span(':~\$ ', _kPlain),
    _Span('cat ', _kFunc),
    _Span('off_duty.txt', _kString),
  ]),
  const _CodeLine([
    _Span('Immersed in Sports · Tinker with new stuff', _kPlain),
  ]),
  const _CodeLine([_Span('', _kPlain)]),
  const _CodeLine([
    _Span('?@surya-tej', _kComment),
    _Span(':~\$ ', _kPlain),
    _Span('status', _kFunc),
  ]),
  const _CodeLine([
    _Span('Building. Always.', _kType),
  ]),
];

/// An animated, self-typing mock code editor window.
/// Loops: types the code out, holds, then clears and retypes.
class CodeTerminal extends StatefulWidget {
  const CodeTerminal({Key? key}) : super(key: key);

  @override
  State<CodeTerminal> createState() => _CodeTerminalState();
}

class _CodeTerminalState extends State<CodeTerminal> {
  final List<String> _typedLines = [];
  int _lineIndex = 0;
  int _charIndex = 0;
  bool _cursorVisible = true;
  Timer? _typeTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      if (!mounted) return;
      setState(() => _cursorVisible = !_cursorVisible);
    });
  }

  void _startTyping() {
    _typedLines.clear();
    _lineIndex = 0;
    _charIndex = 0;
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 28), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final currentLine = _codeLines[_lineIndex];
      if (_charIndex < currentLine.fullText.length) {
        setState(() => _charIndex++);
      } else {
        // Line finished, move to next
        setState(() {
          _typedLines.add(currentLine.fullText);
          _lineIndex++;
          _charIndex = 0;
        });
        if (_lineIndex >= _codeLines.length) {
          timer.cancel();
          // Hold the finished state, then restart the loop
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) _startTyping();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  List<_Span> _visibleSpansFor(_CodeLine line, int chars) {
    final result = <_Span>[];
    var remaining = chars;
    for (final span in line.spans) {
      if (remaining <= 0) break;
      if (span.text.length <= remaining) {
        result.add(span);
        remaining -= span.text.length;
      } else {
        result.add(_Span(span.text.substring(0, remaining), span.color));
        remaining = 0;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTypingLine = _lineIndex < _codeLines.length;
    final List<Widget> lineWidgets = [];

    for (var i = 0; i < _typedLines.length; i++) {
      lineWidgets.add(_buildLine(_codeLines[i].spans, i + 1, showCursor: false));
    }
    if (isTypingLine) {
      final visible = _visibleSpansFor(_codeLines[_lineIndex], _charIndex);
      lineWidgets.add(
        _buildLine(visible, _lineIndex + 1, showCursor: true),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 480, maxHeight: 400),
      child: AspectRatio(
        aspectRatio: 1.05,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.08),
                blurRadius: 60,
                spreadRadius: -10,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title bar
              Container(
                height: 36.0,
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                decoration: const BoxDecoration(
                  color: Color(0xFF2D2D2D),
                ),
                child: Row(
                  children: [
                    _dot(const Color(0xFFFF5F56)),
                    const SizedBox(width: 6.0),
                    _dot(const Color(0xFFFFBD2E)),
                    const SizedBox(width: 6.0),
                    _dot(const Color(0xFF27C93F)),
                    const SizedBox(width: 14.0),
                    Text(
                      'surya@portfolio: ~',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              // Code body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 16.0, 14.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: lineWidgets,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 11.0,
      height: 11.0,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLine(List<_Span> spans, int lineNumber,
      {required bool showCursor}) {
    final textSpans = <InlineSpan>[
      for (final s in spans)
        TextSpan(
          text: s.text,
          style: GoogleFonts.robotoMono(
            color: s.color,
            fontSize: 13.0,
            height: 1.55,
          ),
        ),
      if (showCursor)
        TextSpan(
          text: '\u2588',
          style: GoogleFonts.robotoMono(
            color: _cursorVisible ? kPrimaryColor : Colors.transparent,
            fontSize: 13.0,
            height: 1.55,
          ),
        ),
    ];

    return RichText(text: TextSpan(children: textSpans));
  }
}