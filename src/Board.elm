module Board exposing (Board, availablePositions, full, init, isWinner, positionAvailable, register, size)

import List.Extra as ElmList
import Player exposing (..)


type alias Board =
    List String


emptyPosition =
    ""


init : Int -> Board
init length =
    List.repeat (length * length) emptyPosition


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
    not (List.any (\n -> n == emptyPosition) board)


positionAvailable : Int -> Board -> Bool
positionAvailable position board =
    case ElmList.getAt position board of
        Just "" ->
            True

        Just _ ->
            False

        Nothing ->
            False


availablePositions : Board -> List Int
availablePositions board =
    board
        |> List.indexedMap Tuple.pair
        |> List.filter (\( _, n ) -> n == emptyPosition)
        |> List.map (\( pos, _ ) -> pos)


isWinner : Player -> Board -> Bool
isWinner player board =
    winningLines board
        |> List.map (\line -> sameMark line player)
        |> List.any (\n -> n == True)



--private functions


sameMark : List String -> Player -> Bool
sameMark line player =
    line
        |> List.all (\n -> n == player.mark)


winningLines : Board -> List (List String)
winningLines board =
    let
        rowLines =
            rows board
    in
    rowLines ++ columns rowLines ++ [ left_diagonal rowLines ] ++ [ right_diagonal rowLines ]


rows : Board -> List (List String)
rows board =
    board
        |> ElmList.groupsOf (size board)


columns : List (List String) -> List (List String)
columns rowLines =
    rowLines
        |> ElmList.transpose


left_diagonal : List (List String) -> List String
left_diagonal rowLines =
    rowLines
        |> List.indexedMap Tuple.pair
        |> List.map (\( index, row ) -> ElmList.getAt index row)
        |> List.map (\mark -> Maybe.withDefault emptyPosition mark)


right_diagonal : List (List String) -> List String
right_diagonal rowLines =
    rowLines
        |> List.reverse
        |> left_diagonal
