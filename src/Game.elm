module Game exposing (Game, GameState(..), Msg(..), PositionStatus(..), init, update, view)

import Board exposing (..)
import Html exposing (Html, button, div, p, span, table, td, text, th, tr)
import Html.Events exposing (onClick)
import List.Extra as ElmList
import Player exposing (..)



--TYPES


type Msg
    = NoOp
    | HumanVSHuman
    | HumanVSRandom
    | HumanVSSuper
    | HumanMove Int


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


type GameState
    = NewGame
    | InProgress
    | Won Player
    | Draw


type PositionStatus
    = Valid
    | PositionTaken



--MODEL


type alias Game =
    { state : GameState
    , board : Board
    , currentPlayer : Player
    , opponent : Player
    , positionStatus : Maybe PositionStatus
    }



-- CREATE


init : () -> ( Game, Cmd Msg )
init _ =
    ( { state = NewGame
      , board = Board.init 3
      , currentPlayer = Player "O" Nothing
      , opponent = Player "X" Nothing
      , positionStatus = Nothing
      }
    , Cmd.none
    )



--UPDATE


update : Msg -> Game -> ( Game, Cmd Msg )
update msg ({ state } as game) =
    case msg of
        NoOp ->
            ( game, Cmd.none )

        HumanVSHuman ->
            let
                ( gameInit, _ ) =
                    init ()

                newGame =
                    setMode Human Human gameInit
            in
            ( { newGame | state = InProgress }, Cmd.none )

        HumanVSRandom ->
            let
                ( gameInit, _ ) =
                    init ()

                newGame =
                    setMode Human Random gameInit
            in
            ( { newGame | state = InProgress }, Cmd.none )

        HumanVSSuper ->
            let
                ( gameInit, _ ) =
                    init ()

                newGame =
                    setMode Human Super gameInit
            in
            ( { newGame | state = InProgress }, Cmd.none )

        HumanMove position ->
            if state == InProgress then
                ( nextMove position game, Cmd.none )

            else
                ( game, Cmd.none )



-- VIEW


view : Game -> Document Msg
view game =
    { title = "Hello"
    , body =
        [ div [] [ text "Play new game as: " ]
        , button [ onClick HumanVSHuman ] [ text "Human vs Human" ]
        , button [ onClick HumanVSRandom ] [ text "Human vs Random" ]
        , button [ onClick HumanVSSuper ] [ text "Human vs Super" ]
        ]
    }



--TRANSFORM


setMode : TypePlayer -> TypePlayer -> Game -> Game
setMode type1 type2 ({ currentPlayer, opponent } as game) =
    { game | currentPlayer = Player.init type1 currentPlayer, opponent = Player.init type2 opponent }


nextMove : Int -> Game -> Game
nextMove position currentGame =
    let
        game =
            currentGame |> validatePosition position
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
