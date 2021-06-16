import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/types.dart' as types;
import 'package:flutter_stateless_chessboard/widgets/chess_piece.dart';
import 'package:flutter_stateless_chessboard/widgets/square.dart';

class ChessSquare extends StatelessWidget {
  final String? name;
  final Color color;
  final Color? highlightColor;
  final Color? secondHighlightColor;
  final double size;
  final types.Piece? piece;
  final void Function(types.ShortMove move)? onDrop;
  final void Function(types.HalfMove move)? onClick;
  final bool highlight;
  final bool hightlightLastMove;
  final bool canBeDragged;

  ChessSquare({
    this.name,
    required this.color,
    required this.size,
    this.highlightColor,
    this.highlight = false,
    this.piece,
    this.onDrop,
    this.onClick,
    this.hightlightLastMove = false,
    this.secondHighlightColor,
    this.canBeDragged = true,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<types.HalfMove>(
      onWillAccept: (data) {
        return data!.square != name;
      },
      onAccept: (data) {
        if (onDrop != null) {
          onDrop!(types.ShortMove(
            from: data.square,
            to: name,
            promotion: types.PieceType.QUEEN,
          ));
        }
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onPanDown: (_) {
            if (onClick != null) {
              onClick!(types.HalfMove(name, piece));
            }
          },
          child: Square(
            size: size,
            color: color,
            highlightColor:
                hightlightLastMove ? secondHighlightColor : highlightColor,
            highlight: highlight || hightlightLastMove,
            child: piece != null
                ? ChessPiece(
                    canBeDragged: canBeDragged,
                    squareName: name,
                    squareColor: color,
                    piece: piece,
                    size: size,
                  )
                : null,
          ),
        );
      },
    );
  }
}
