import 'package:flutter/material.dart';

import 'package:flutter_stateless_chessboard/types.dart'
    show ShortMove, PieceType;

import 'package:chess/chess.dart' as ch;

class ChessboardController extends ChangeNotifier {
  late ch.Chess _board;
  String? _selectedSqaure;
  late bool enableInteraction;

  ChessboardController({
    required String fen,
    String? selectedSqaure,
    this.enableInteraction = true,
  }) {
    _board = ch.Chess.fromFEN(fen);
    _selectedSqaure = selectedSqaure;
  }

  bool canMove(ShortMove move) {
    var copy = _board.copy();
    return copy.move({
      'from': move.from,
      'to': move.to,
      'promotion': 'q',
    });
  }

  bool playMove(ShortMove move) {
    bool hasMoved = _board.move({
      'from': move.from,
      'to': move.to,
      'promotion': 'q',
    });
    if (hasMoved) {
      notifyListeners();
    }
    return hasMoved;
  }

  void undoMove() {
    _board.undo();
  }

  String get fen {
    return _board.fen;
  }

  void setupNewBoard(String) {
    _board = ch.Chess.fromFEN(fen);
  }

  ShortMove? get latestMove {
    if (_board.history.isNotEmpty) {
      return ShortMove(
          from: _board.history.last.move.fromAlgebraic,
          to: _board.history.last.move.toAlgebraic,
          promotion: _board.history.last.move.promotion != null
              ? PieceType.fromString(_board.history.last.move.promotion!.name)
              : null);
    }
    return null;
  }

  String? get latestMoveAsSAN {
    if (_board.history.isNotEmpty) {
      var copy = _board.copy();
      copy.undo();
      return copy.move_to_san(_board.history.last.move);
    }
    return null;
  }

  String? get selectedSqaure {
    return _selectedSqaure;
  }

  set selectedSqaure(String? selectedSqaure) {
    _selectedSqaure = selectedSqaure;
    notifyListeners();
  }
}
