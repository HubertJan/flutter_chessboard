import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart'
    as cb;

import 'utils.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  cb.ShortMove? _lastMove;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;
    final size = min(viewport.height, viewport.width);

    return Scaffold(
      appBar: AppBar(
        title: Text("Random Chess"),
      ),
      body: Center(
        child: cb.Chessboard(
          fen: _fen!,
          lastMove: _lastMove,
          size: size,
          orientation: cb.Color.WHITE,
          onMove: (move) {
            _lastMove = move;
            final nextFen = makeMove(_fen!, {
              'from': move.from,
              'to': move.to,
              'promotion': 'q',
            });

            if (nextFen != null) {
              setState(() {
                _fen = nextFen;
              });

              Future.delayed(Duration(milliseconds: 300)).then((_) {
                final nextMove = getRandomMove(_fen!);
                _lastMove = getShortMove(_fen!, nextMove);
                if (nextMove != null) {
                  setState(() {
                    _fen = makeMove(_fen!, nextMove);
                  });
                }
              });
            }
          },
        ),
      ),
    );
  }
}
