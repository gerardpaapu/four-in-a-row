{Position, Piece, Board, Result} = require './Board.coffee'

memoize = (fn) ->
    table = {}

    return ->
        args = Array::slice.call arguments
        key = [this, args...].join ':'

        if table.hasOwnProperty(key)
            table[key]
        else
            table[key] = fn args...

class GameState
    constructor: (@board, @player) ->
    # board - an instance of Board
    # player - this player has the next move 
    nextMoves: ->
        for index in @board.playableColumns()
            new GameState @board.playAt(@player, index), @nextPlayer()

    nextPlayer: ->
        if @player is Piece.Red
            Piece.Yellow
        else
            Piece.Red

    isComplete: ->
        @board.result() isnt Result.Unfinished

    isWin: -> 
        result = @board.result() 

        playerWins = if @player is Piece.Red
            Result.YellowWins
        else
            Result.RedWins

        result is playerWins
    
    isntWin: -> not @isWin()

    isGood: memoize ->
        @isWin() or @nextMoves().every (move) -> move.isBad()

    isBad: memoize ->
        @isntWin() and @nextMoves().any (move) -> move.isGood()

    isOkay: -> not @isBad()

    goodMoves: ->
        @nextMoves.filter (move) -> move.isGood()

    badMoves: ->
        @nextMoves.filter (move) -> move.isBad()

    okayMoves: ->
        @nextMoves.filter (move) -> move.isOkay()

    toString: ->
        @board.toString() + ':' + @player

if typeof module != 'undefined' and module.exports
    module.exports.GameState = GameState 
