library flutter_chessboard;

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/types.dart' as types;
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/chessboard_controller.dart';
import 'package:flutter_stateless_chessboard/widgets/chess_square.dart';
import 'package:flutter_stateless_chessboard/types.dart' show ShortMove;

export 'package:flutter_stateless_chessboard/types.dart';
export 'package:flutter_stateless_chessboard/chessboard_controller.dart';

import 'package:chess/chess.dart' as ch;

final zeroToSeven = List.generate(8, (index) => index);

class Chessboard extends StatefulWidget {
  final double size;
  final types.Color orientation;
  final void Function(types.ShortMove move)? onMove;
  final Color lightSquareColor;
  final Color darkSquareColor;
  final Color highlightColor;
  final Color secondHighlightColor;
  final ChessboardController controller;

  Chessboard({
    required this.size,
    required this.controller,
    this.orientation = types.Color.WHITE,
    this.onMove,
    this.lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    this.darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
    this.highlightColor = Colors.yellow,
    this.secondHighlightColor = Colors.orange,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChessboardState();
  }
}

class _ChessboardState extends State<Chessboard> {
  types.HalfMove? _clicked;

  @override
  Widget build(BuildContext context) {
    final squareSize = widget.size / 8;
    final pieceMap = getPieceMap(widget.controller.fen);

    return Container(
      width: widget.size,
      height: widget.size,
      child: Row(
        children: zeroToSeven.map((fileIndex) {
          return Column(
            children: zeroToSeven.map((rankIndex) {
              final square =
                  getSquare(rankIndex, fileIndex, widget.orientation);
              final color = (rankIndex + fileIndex) % 2 == 0
                  ? widget.lightSquareColor
                  : widget.darkSquareColor;
              return ChessSquare(
                name: square,
                color: color,
                highlightColor: widget.highlightColor,
                secondHighlightColor: widget.secondHighlightColor,
                size: squareSize,
                highlight: _clicked?.square == square,
                hightlightLastMove:
                    widget.controller.latestMove?.from == square ||
                        widget.controller.latestMove?.to == square,
                piece: pieceMap[square],
                canBeDragged: widget.controller.enableInteraction,
                onDrop: (move) {
                  if (widget.onMove != null &&
                      widget.controller.canMove(move)) {
                    widget.onMove!(move);
                    _clicked = null;
                    setState(() {});
                  }
                },
                onClick: (halfMove) {
                  if (!widget.controller.enableInteraction) {
                    return;
                  }

                  if (_clicked != null) {
                    if (_clicked!.piece!.color == halfMove.piece?.color) {
                      _clicked = halfMove;
                      setState(() {});
                    } else {
                      var move = types.ShortMove(
                        from: _clicked!.square,
                        to: halfMove.square,
                        promotion: types.PieceType.QUEEN,
                      );
                      if (widget.controller.canMove(move)) {
                        widget.onMove!(move);
                      }
                      _clicked = null;
                      setState(() {});
                    }
                  } else if (halfMove.piece != null) {
                    _clicked = halfMove;
                    setState(() {});
                  }
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
