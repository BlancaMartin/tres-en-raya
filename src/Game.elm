module Game exposing (GameState(..), PositionStatus(..), init, nextMove, setMode)

import Board exposing (..)
import List.Extra as ElmList
import Player exposing (..)


type GameState
    = NewGame
    | InProgress
    | Won Player
    | Draw


type PositionStatus
    = Valid
    | PositionTaken


type alias Game =
    { state : GameState
    , board : Board
    , currentPlayer : Player
    , opponent : Player
    , positionStatus : Maybe PositionStatus
    }


init : Game
init =
    { state = NewGame
    , board = Board.init 3
    , currentPlayer = Player "O" Nothing
    , opponent = Player "X" Nothing
    , positionStatus = Nothing
    }


setMode : TypePlayer -> TypePlayer -> Game -> Game
setMode type1 type2 ({ currentPlayer, opponent } as game) =
    { game | currentPlayer = Player.init type1 currentPlayer, opponent = Player.init type2 opponent }


nextMove : Int -> Game -> Game
nextMove position currentGame =
    let
        game =
            currentGame
                |> validatePosition position
    in
    if game.positionStatus == Just Valid then
        game
            |> updateBoard position
            |> updateState
            |> swapPlayers

    else
        game



-- private functions


validatePosition : Int -> Game -> Game
validatePosition position ({ currentPlayer, board } as game) =
    let
        updatedPositionStatus =
            if Board.positionAvailable position board then
                Just Valid

            else
                Just PositionTaken
    in
    { game | positionStatus = updatedPositionStatus }


swapPlayers : Game -> Game
swapPlayers ({ currentPlayer, opponent } as game) =
    { game | currentPlayer = opponent, opponent = currentPlayer }


updateState : Game -> Game
updateState ({ currentPlayer, opponent, board } as game) =
    let
        updatedState =
            if Board.isWinner currentPlayer board then
                Won currentPlayer

            else if Board.isWinner opponent board then
                Won opponent

            else if Board.full board then
                Draw

            else
                InProgress
    in
    { game | state = updatedState }


updateBoard : Int -> Game -> Game
updateBoard position ({ currentPlayer, board } as game) =
    { game | board = Board.register position currentPlayer board }
