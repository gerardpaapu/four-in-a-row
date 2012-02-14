(function() {
  var Board, Piece, Position, Result;

  Board = (function() {

    function Board() {}

    Board.prototype.width = 7;

    Board.prototype.height = 6;

    Board.prototype.getColumn = function(x) {
      var column, _base, _ref;
      if (x > this.width) return null;
      if (this.columns == null) this.columns = [];
      return column = (_ref = (_base = this.columns)[x]) != null ? _ref : _base[x] = [];
    };

    Board.prototype.get = function(x, y) {
      var _ref;
      return (_ref = this.getColumn(x)[y]) != null ? _ref : Position.Empty;
    };

    Board.prototype.isColumnFull = function(x) {
      console.log("h: " + this.height + ", l: " + (this.getColumn(x).length));
      return this.height <= this.getColumn(x).length;
    };

    Board.prototype.playableColumns = function() {
      var i, _ref, _results;
      _results = [];
      for (i = 0, _ref = this.width - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        if (!this.isColumnFull(i)) _results.push(i);
      }
      return _results;
    };

    Board.prototype.playAt = function(piece, x) {
      if (this.isColumnFull(x)) throw new Error("Column " + x + " is full");
      return this.getColumn(x).push(piece);
    };

    return Board;

  })();

  Piece = {
    Red: 'Red',
    Yellow: 'Yellow'
  };

  Position = {
    Red: 'Red',
    Yellow: 'Yellow',
    Empty: 'Empty',
    sigilFor: function(p) {
      switch (p) {
        case Position.Red:
          return 'O';
        case Position.Yellow:
          return 'X';
        case Position.Empty:
          return '_';
      }
    }
  };

  Result = {
    RedWins: 'RedWins',
    YellowWins: 'YellowWins',
    StaleMate: 'StaleMate',
    Unfinished: 'Unfinished'
  };

  Board.prototype.result = function() {
    var result, x, y, _ref, _ref2;
    console.log("playable: " + (this.playableColumns()));
    if (this.playableColumns().length === 0) return RedWins.StaleMate;
    for (y = 0, _ref = this.height; 0 <= _ref ? y <= _ref : y >= _ref; 0 <= _ref ? y++ : y--) {
      for (x = 0, _ref2 = this.width; 0 <= _ref2 ? x <= _ref2 : x >= _ref2; 0 <= _ref2 ? x++ : x--) {
        result = this.checkPositionForResult(x, y);
        if (result !== Result.Unfinished) return result;
      }
    }
    return Result.Unfinished;
  };

  Board.prototype.checkPositionForResult = function(x, y) {
    var current, i, match, winner;
    current = this.get(x, y);
    if (current === Position.Empty) return Result.Unfinished;
    winner = current === Piece.Red ? Result.RedWins : Result.YellowWins;
    match = function(ls) {
      return ls.every(function(a) {
        return a === current;
      });
    };
    if (this.width - x >= 3) {
      if (match((function() {
        var _results;
        _results = [];
        for (i = 1; i <= 3; i++) {
          _results.push(this.get(x + i, y));
        }
        return _results;
      }).call(this))) {
        return winner;
      }
    }
    if (this.width - x >= 3 && this.height - y > 4) {
      if (match((function() {
        var _results;
        _results = [];
        for (i = 1; i <= 3; i++) {
          _results.push(this.get(x + i, y + i));
        }
        return _results;
      }).call(this))) {
        return winner;
      }
    }
    if (x >= 3 && this.height - y > 4) {
      if (match((function() {
        var _results;
        _results = [];
        for (i = 1; i <= 3; i++) {
          _results.push(this.get(x - i, y + i));
        }
        return _results;
      }).call(this))) {
        return winner;
      }
    }
    if (this.height - y >= 3) {
      if (match((function() {
        var _results;
        _results = [];
        for (i = 1; i <= 3; i++) {
          _results.push(this.get(x, y + i));
        }
        return _results;
      }).call(this))) {
        return winner;
      }
    }
    return Result.Unfinished;
  };

  Board.prototype.draw = function() {
    var lines, x, y;
    lines = (function() {
      var _ref, _results;
      _results = [];
      for (y = _ref = this.height - 1; _ref <= 0 ? y <= 0 : y >= 0; _ref <= 0 ? y++ : y--) {
        _results.push(((function() {
          var _ref2, _results2;
          _results2 = [];
          for (x = 0, _ref2 = this.width - 1; 0 <= _ref2 ? x <= _ref2 : x >= _ref2; 0 <= _ref2 ? x++ : x--) {
            _results2.push(Position.sigilFor(this.get(x, y)));
          }
          return _results2;
        }).call(this)).join(''));
      }
      return _results;
    }).call(this);
    return lines.join('\n');
  };

  if (typeof module !== 'undefined') {
    module.exports.Board = Board;
    module.exports.Piece = Piece;
    module.exports.Position = Position;
    module.exports.Result = Result;
  }

}).call(this);
