import 'package:flutter/material.dart';

import 'package:flutter_stateless_chessboard/types.dart' show ShortMove;

class ChessboardController extends ChangeNotifier {
  late String _fen;
  ShortMove? _lastMove;
  String? _selectedSqaure;

  ChessboardController({
    required String fen,
    ShortMove? lastMove,
    String? selectedSqaure,
  }) {
    _fen = fen;
    _selectedSqaure = selectedSqaure;
    _lastMove = lastMove;
  }

  String get fen {
    return _fen;
  }

  set fen(String fen) {
    _fen = fen;
    notifyListeners();
  }

  ShortMove? get lastMove {
    return _lastMove;
  }

  set lastMove(ShortMove? lastMove) {
    _lastMove = lastMove;
    notifyListeners();
  }

  String? get selectedSqaure {
    return _selectedSqaure;
  }

  set selectedSqaure(String? selectedSqaure) {
    _selectedSqaure = selectedSqaure;
    notifyListeners();
  }
}
