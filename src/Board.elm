module Board exposing (Board, availablePositions, full, init, isWinner, positionAvailable, register, size)

import List.Extra as ElmList
import Mark exposing (..)
import Player exposing (..)



-- TYPES


type alias Board =
    List Mark



-- CREATE


init : Int -> Board
init length =
    List.repeat (length * length) Empty



-- TRANSFORM


size : Board -> Int
size board =
    board
        |> List.length
        |> toFloat
        |> sqrt
        |> truncate


register : Int -> Player -> Board -> Board
register position player board =
    ElmList.updateAt position (\_ -> player.mark) board


full : Board -> Bool
full board =
    not (List.any (\n -> n == Empty) board)


positionAvailable : Int -> Board -> Bool
positionAvailable position board =
    case ElmList.getAt position board of
        Just Empty ->
            True

        _ ->
            False


availablePositions : Board -> List Int
availablePositions board =
    board
        |> List.indexedMap Tuple.pair
        |> List.filter (\( _, n ) -> n == Empty)
        |> List.map (\( pos, _ ) -> pos)


isWinner : Player -> Board -> Bool
isWinner player board =
    winningLines board
        |> List.map (\line -> sameMark line player)
        |> List.any (\n -> n == True)



--private functions


sameMark : List Mark -> Player -> Bool
sameMark line player =
    line
        |> List.all (\n -> n == player.mark)


winningLines : Board -> List (List Mark)
winningLines board =
    let
        rowLines =
            rows board
    in
    rowLines ++ columns rowLines ++ [ left_diagonal rowLines ] ++ [ right_diagonal rowLines ]


rows : Board -> List (List Mark)
rows board =
    board
        |> ElmList.groupsOf (size board)


columns : List (List Mark) -> List (List Mark)
columns rowLines =
    rowLines
        |> ElmList.transpose


left_diagonal : List (List Mark) -> List Mark
left_diagonal rowLines =
    rowLines
        |> List.indexedMap Tuple.pair
        |> List.map (\( index, row ) -> ElmList.getAt index row)
        |> List.map (\mark -> Maybe.withDefault Empty mark)


right_diagonal : List (List Mark) -> List Mark
right_diagonal rowLines =
    rowLines
        |> List.reverse
        |> left_diagonal
