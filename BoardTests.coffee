assert = require 'assert'
{Position, Piece, Board, Result} = require './Board.coffee'
{Red, Yellow} = Position
{RedWins, YellowWins, Unfinished, StaleMate} = Result

assertResult = (arr, res) ->
    b = new Board
    b.columns = arr
    console.log "Expecting #{res}"
    console.log b.toString()
    assert.equal(b.result(), res)

assertResult [], Unfinished 
assertResult [[Red, Red, Red, Red]], RedWins
assertResult [[Yellow, Yellow, Red, Red, Red, Red]], RedWins
assertResult [[Yellow, Yellow, Yellow, Yellow]], YellowWins
assertResult [[Red], [Red], [Red], [Red]], RedWins
assertResult [[], [], [], [], [Red], [Red], [Red], [Red]], RedWins
assertResult [[Red], [Yellow, Red], [Red, Yellow, Red], [Yellow, Red, Yellow, Red]], RedWins
assertResult [[Yellow, Red, Yellow, Red], [Red, Yellow, Red], [Yellow, Red], [Red]], RedWins
assertResult [[], [], [], [Red], [Yellow, Red], [Red, Yellow, Red], [Yellow, Red, Yellow, Red]], RedWins
assertResult [[], [], [], [Yellow, Red, Yellow, Red], [Red, Yellow, Red], [Yellow, Red], [Red]], RedWins
assertResult [
    [Yellow, Red, Yellow, Red, Yellow, Red],
    [Yellow, Red, Yellow, Red, Yellow, Red],
    [Red, Yellow, Red, Yellow, Red, Yellow],
    [Red, Yellow, Red, Yellow, Red, Yellow],
    [Yellow, Red, Yellow, Red, Yellow, Red],
    [Yellow, Red, Yellow, Red, Yellow, Red],
    [Red, Yellow, Red, Yellow, Red, Yellow]], StaleMate

b = new Board
b2 = b.playAt Piece.Red, 0
console.log( b2.toString() )

{GameState} = require './Search.coffee'

g = new GameState b, Piece.Red 
console.log( g.toString() )
console.log( n.toString() for n in g.nextMoves() )
