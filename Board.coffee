class Board
    width: 7
    height: 6

    getColumn: (x) ->
        return null if x > @width

        @columns ?= []
        @columns[x] ?= []
    
    get: (x, y) ->
        @getColumn(x)[y] ? Position.Empty

    isColumnFull: (x) ->
        @height <= @getColumn(x).length

    playableColumns: ->
        i for i in [0..@width-1] when not @isColumnFull i

    clone: ->
        b = new Board
        b.columns = for column in @columns
            item for item in column
                
        return b

    playAt: (piece, x) ->
        throw new Error "Column #{x} is full" if @isColumnFull(x)
        b = @clone() 
        b.getColumn(x).push Position.fromPiece(piece)      
        return b

Piece = 
    Red: 'Red'
    Yellow: 'Yellow'

Position = 
    Red: 'Red'
    Yellow: 'Yellow'
    Empty: 'Empty'

    fromPiece: (p) ->
        switch p
            when Piece.Red then Position.Red
            when Piece.Yellow then Position.Yellow

    sigilFor: (p) ->
        switch p
            when Position.Red then 'R'
            when Position.Yellow then 'Y'
            when Position.Empty then '.'

Result =
    RedWins: 'RedWins'
    YellowWins: 'YellowWins'
    StaleMate: 'StaleMate'
    Unfinished: 'Unfinished'

Board::result = ->

    for y in [0..@height-1]
        for x in [0..@width-1]
            result = @checkPositionForResult x, y
            if result != Result.Unfinished
                return result 

    if @playableColumns().length is 0
        Result.StaleMate
    else 
        Result.Unfinished

Board::checkPositionForResult = (x, y) ->
    current = @get(x, y)

    return Result.Unfinished if current is Position.Empty

    winner = if current is Piece.Red
        Result.RedWins
    else
        Result.YellowWins

    match = (ls) ->
        ls.every (a) -> a is current

    # check left to right (horizontal)
    if @width - x >= 3
        if match(@get(x + i, y) for i in [1..3])
            return winner

    # check top-left to bottom-right (diagonal)
    if @width - x >= 3 and @height - y > 4 
        if match(@get(x + i, y + i) for i in [1..3]) 
            return winner

    # check top-right to bottom-left (diagonal)
    if x >= 3 and @height - y > 4
        if match(@get(x - i, y + i) for i in [1..3]) 
            return winner

    # check top to bottom (vertical)
    if @height - y >= 3
        if match(@get(x, y + i) for i in [1..3])
            return winner

    return Result.Unfinished

Board::toString = ->
    lines = for y in [@height-1..0]
        (Position.sigilFor(@get(x, y)) for x in [0..@width-1]).join ''

    lines.join '\n'

if typeof module != 'undefined'
    module.exports.Board = Board
    module.exports.Piece = Piece
    module.exports.Position = Position
    module.exports.Result = Result
