module Board exposing (Board, availablePositions, full, init, isWinner, positionAvailable, register, size, winnerLine)

import Dict exposing (..)
import List.Extra as ElmList
import Mark exposing (..)
import Player exposing (..)



-- TYPES


type alias Board =
    Dict Int Mark


type alias Line =
    List ( Int, Mark )



-- CREATE


init : Int -> Board
init length =
    List.repeat (length * length) Empty
        |> List.indexedMap Tuple.pair
        |> Dict.fromList



-- TRANSFORM


size : Board -> Int
size board =
    board
        |> Dict.size
        |> toFloat
        |> sqrt
        |> truncate


register : Int -> Player -> Board -> Board
register position player board =
    board
        |> Dict.update position (Maybe.map (\_ -> player.mark))


full : Board -> Bool
full board =
    not <|
        (board
            |> Dict.values
            |> List.any (\position -> position == Empty)
        )


positionAvailable : Int -> Board -> Bool
positionAvailable position board =
    case Dict.get position board of
        Just Empty ->
            True

        _ ->
            False


availablePositions : Board -> List Int
availablePositions board =
    board
        |> Dict.filter (\_ position -> position == Empty)
        |> Dict.keys


isWinner : Player -> Board -> Bool
isWinner player board =
    winningLines board
        |> List.map (\line -> sameMark line player)
        |> List.any (\match -> match == True)


winnerLine : Player -> Board -> List Int
winnerLine winner board =
    winningLines board
        |> List.map (\line -> positionsWinnerLine line winner)
        |> List.filter (\line -> line /= [])
        |> List.head
        |> Maybe.withDefault []



--private functions


positionsWinnerLine : Line -> Player -> List Int
positionsWinnerLine line winner =
    if sameMark line winner then
        line
            |> Dict.fromList
            |> Dict.keys

    else
        []


sameMark : Line -> Player -> Bool
sameMark line player =
    line
        |> List.all (\( _, mark ) -> mark == player.mark)


winningLines : Board -> List Line
winningLines board =
    let
        rowLines =
            rows board
    in
    rowLines ++ columns rowLines ++ [ left_diagonal rowLines ] ++ [ right_diagonal rowLines ]


rows : Board -> List Line
rows board =
    board
        |> Dict.toList
        |> ElmList.groupsOf (size board)


columns : List Line -> List Line
columns rowLines =
    rowLines
        |> ElmList.transpose


left_diagonal : List Line -> Line
left_diagonal rowLines =
    rowLines
        |> List.indexedMap Tuple.pair
        |> List.map (\( index, row ) -> ElmList.getAt index row)
        |> List.map (\indexMark -> Maybe.withDefault ( 0, Empty ) indexMark)


right_diagonal : List Line -> Line
right_diagonal rowLines =
    rowLines
        |> List.reverse
        |> left_diagonal
