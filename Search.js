(function() {
  var Board, GameState, Piece, Position, Result, memoize, _ref,
    __slice = Array.prototype.slice;

  _ref = require('./Board.coffee'), Position = _ref.Position, Piece = _ref.Piece, Board = _ref.Board, Result = _ref.Result;

  memoize = function(fn) {
    var table;
    table = {};
    return function() {
      var args, key;
      args = Array.prototype.slice.call(arguments);
      key = [this].concat(__slice.call(args)).join(':');
      if (table.hasOwnProperty(key)) {
        return table[key];
      } else {
        return table[key] = fn.apply(null, args);
      }
    };
  };

  GameState = (function() {

    function GameState() {}

    GameState.prototype.initialize = function(board, player) {
      this.board = board;
      this.player = player;
    };

    GameState.prototype.nextMoves = function() {
      var index, _i, _len, _ref2, _results;
      _ref2 = this.board.playableColumns();
      _results = [];
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        index = _ref2[_i];
        _results.push(new GameState(this.board.playAt(index), this.nextPlayer()));
      }
      return _results;
    };

    GameState.prototype.nextPlayer = function() {
      if (this.player === Piece.Red) {
        return Piece.Yellow;
      } else {
        return Piece.Red;
      }
    };

    GameState.prototype.isComplete = function() {
      return this.board.result() !== Result.Incomplete;
    };

    GameState.prototype.isWin = function() {
      var playerWins, result;
      result = this.board.result();
      playerWins = this.player === Piece.Red ? Result.RedWins : Result.YellowWins;
      return result === playerWins;
    };

    GameState.prototype.isntWin = function() {
      return !this.isWin();
    };

    GameState.prototype.isGood = memoize(function() {
      return this.isWin() || this.nextMoves().every(function(move) {
        return move.isBad();
      });
    });

    GameState.prototype.isBad = memoize(function() {
      return this.isntWin() && this.nextMoves().any(function(move) {
        return move.isGood();
      });
    });

    GameState.prototype.isOkay = function() {
      return !this.isBad();
    };

    GameState.prototype.goodMoves = function() {
      return this.nextMoves.filter(function(move) {
        return move.isGood();
      });
    };

    GameState.prototype.badMoves = function() {
      return this.nextMoves.filter(function(move) {
        return move.isBad();
      });
    };

    GameState.prototype.okayMoves = function() {
      return this.nextMoves.filter(function(move) {
        return move.isOkay();
      });
    };

    GameState.prototype.toString = function() {
      return this.board.toString() + ':' + this.player;
    };

    return GameState;

  })();

  if (typeof module !== 'undefined' && module.exports) {
    module.exports.GameState = GameState;
  }

}).call(this);
