{Position, Piece, Board, Result} = require './Board.coffee'

memoize = (fn) ->
    table = {}

    return ->
        args = Array::slice.call arguments
        key = [this, args...].join ':'

        if table.hasOwnProperty(key)
            table[key]
        else
            table[key] = fn.apply(@, args)

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

    isGood: memoize (depth=GameState.search_depth) ->
        if depth is 0
            false
        else if @isWin() 
            true
        else
            moves = @nextMoves()
            moves.length > 0 and moves.every (move) -> move.isBad(depth - 1)

    isBad: memoize (depth=GameState.search_depth) ->
        depth > 0 and @isntWin() and @nextMoves().some (move) -> move.isGood(depth - 1)

    isOkay: (depth=GameState.search_depth) -> not @isBad(depth)

    goodMoves: (depth=GameState.search_depth) ->
        @nextMoves().filter (move) -> move.isGood(depth)

    badMoves: (depth=GameState.search_depth) ->
        @nextMoves().filter (move) -> move.isBad(depth)

    okayMoves: (depth=GameState.search_depth) ->
        @nextMoves().filter (move) -> move.isOkay(depth)

    @search_depth: 5

    toString: ->
        @board.toString() + ':' + @player


if typeof module != 'undefined' and module.exports
    module.exports.GameState = GameState 
