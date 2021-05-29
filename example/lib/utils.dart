import 'package:chess/chess.dart' as ch;
import 'package:flutter_stateless_chessboard/types.dart' show ShortMove;

String? makeMove(String fen, dynamic move) {
  final chess = ch.Chess.fromFEN(fen);

  if (chess.move(move)) {
    return chess.fen;
  }

  return null;
}

String? getRandomMove(String fen) {
  final chess = ch.Chess.fromFEN(fen);

  final moves = chess.moves();

  if (moves.isEmpty) {
    return null;
  }

  moves.shuffle();

  return moves.first;
}

ShortMove? getShortMove(String fen, dynamic move) {
  final chess = ch.Chess.fromFEN(fen);
  if (chess.move(move)) {
    return ShortMove(
        from: chess.history.last.move.fromAlgebraic,
        to: chess.history.last.move.toAlgebraic);
  }
}
