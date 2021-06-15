import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/chessboard_controller.dart';
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
  late ChessboardController _controller;
  cb.ShortMove? _lastMove;

  @override
  void initState() {
    _controller = ChessboardController(
        fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');
    super.initState();
  }

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
          controller: _controller,
          size: size,
          orientation: cb.Color.WHITE,
          onMove: (move) {
            _lastMove = move;
            Future.delayed(Duration(milliseconds: 300)).then((_) {
              final nextMove = getRandomMove(_controller.fen);
              _controller.lastMove = getShortMove(_controller.fen, nextMove);
              if (nextMove != null) {
                setState(() {
                  _controller.fen = makeMove(_controller.fen, nextMove)!;
                });
              }
            });
          },
        ),
      ),
    );
  }
}
