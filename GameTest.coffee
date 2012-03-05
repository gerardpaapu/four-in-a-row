{Position, Piece, Board, Result} = require './Board.coffee'
{GameState} = require './Search.coffee'

chooseRandom = (arr) ->
    if arr.length is 0
        undefined
    else 
        arr[ Math.floor(Math.random() * arr.length) ]

game = new GameState new Board, Piece.Red

until game.isComplete()
    moves = game.okayMoves()

    if moves.length > 0 
        game = chooseRandom( moves )
    else 
        console.log "#{game.player} concedes"
        console.log '----------------'
        break

console.log game.board.toString()
console.log '----------------'
console.log game.board.result()
