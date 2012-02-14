{Position, Piece, Board, Result} = require './Board.coffee'
{GameState} = require './Search.coffee'

chooseRandom = (arr) ->
    if arr.length is 0
        undefined
    else 
        arr[ Math.floor(Math.random() * arr.length) ]


game = new GameState new Board, Piece.Red
console.log game.board.result()

console.log game.board.toString()
console.log '------'

until game.isComplete()
    game = chooseRandom( game.nextMoves() )
    console.log game.board.toString()
    console.log '-------'

console.log game.board.result()
