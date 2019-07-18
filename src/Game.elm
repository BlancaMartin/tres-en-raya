module Game exposing (Game, GameState(..), Msg(..), PositionStatus(..), getBestPosition, init, update, view)

import Board exposing (..)
import Debug
import Html exposing (Html, button, div, p, span, table, td, text, th, tr)
import Html.Events exposing (onClick)
import List.Extra as ElmList
import Player exposing (..)
import Random exposing (..)
import Random.Extra as ElmRandom



--TYPES


type Msg
    = NoOp
    | HumanVsHuman
    | HumanVsRandom
    | HumanVsSuper
    | MakeMove Int
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


type alias ScoredPosition =
    { position : Int
    , score : Int
    }



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
update msg ({ state, currentPlayer, opponent } as game) =
    case msg of
        NoOp ->
            ( game, Cmd.none )

        HumanVsHuman ->
            let
                newGame =
                    init ()
                        |> Tuple.first
                        |> setMode Human Human
            in
            ( { newGame | state = InProgress }, Cmd.none )

        HumanVsRandom ->
            let
                newGame =
                    init ()
                        |> Tuple.first
                        |> setMode Human Random
            in
            ( { newGame | state = InProgress }, Cmd.none )

        HumanVsSuper ->
            let
                newGame =
                    init ()
                        |> Tuple.first
                        |> setMode Human Super
            in
            ( { newGame | state = InProgress }, Cmd.none )

        MakeMove position ->
            if state == InProgress then
                ( nextMove position game, Cmd.none )

            else
                ( game, Cmd.none )

        HumanMove position ->
            if currentPlayer.typePlayer == Just Human then
                if state == InProgress then
                    let
                        nextGame =
                            nextMove position game
                    in
                    if nextGame.positionStatus == Just Valid then
                        case opponent.typePlayer of
                            Just Random ->
                                ( nextGame, Random.generate MakeMove (getRandomPosition nextGame) )

                            Just Super ->
                                ( nextMove (getBestPosition nextGame) nextGame, Cmd.none )

                            _ ->
                                ( nextGame, Cmd.none )

                    else
                        ( nextGame, Cmd.none )

                else
                    ( game, Cmd.none )

            else
                ( game, Cmd.none )



-- VIEW


view : Game -> Document Msg
view game =
    { title = "Tic tac toe"
    , body =
        [ div [] [ viewState game ]
        , viewBoard game.board
        , viewPlayer game.currentPlayer
        , div [] [ text "Play new game as: " ]
        , button [ onClick HumanVsHuman ] [ text "Human vs Human" ]
        , button [ onClick HumanVsRandom ] [ text "Human vs Random" ]
        , button [ onClick HumanVsSuper ] [ text "Human vs Super" ]
        ]
    }


viewState : Game -> Html Msg
viewState game =
    case game.state of
        Won player ->
            text "yayy won"

        Draw ->
            text "its a draw"

        InProgress ->
            text "keep playing!"

        _ ->
            text "New game"


viewPlayer : Player -> Html Msg
viewPlayer player =
    text player.mark


viewBoard : Board -> Html Msg
viewBoard board =
    board
        |> List.indexedMap Tuple.pair
        |> ElmList.groupsOf (Board.size board)
        |> List.map (\row -> viewRow row)
        |> table []


viewRow : List ( Int, String ) -> Html Msg
viewRow row =
    row
        |> List.map (\( index, position ) -> viewPosition index position)
        |> tr []


viewPosition : Int -> String -> Html Msg
viewPosition index position =
    button [ onClick (HumanMove index) ] [ text position ]



--TRANSFORM


setMode : TypePlayer -> TypePlayer -> Game -> Game
setMode type1 type2 ({ currentPlayer, opponent } as game) =
    { game | currentPlayer = Player.addType type1 currentPlayer, opponent = Player.addType type2 opponent }


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


getRandomPosition : Game -> Generator Int
getRandomPosition game =
    game.board
        |> Board.availablePositions
        |> ElmRandom.sample
        |> map (Maybe.withDefault 0)


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



--MINIMAX


getBestPosition : Game -> Int
getBestPosition game =
    allPositionsScored game 0
        |> highestScoredPosition


highestScoredPosition : List ScoredPosition -> Int
highestScoredPosition positionsScored =
    positionsScored
        |> ElmList.maximumBy (\{ position, score } -> score)
        |> Maybe.withDefault (ScoredPosition 0 0)
        |> .position


allPositionsScored : Game -> Int -> List ScoredPosition
allPositionsScored game depth =
    game.board
        |> Board.availablePositions
        |> List.map (\position -> scoreEachPosition position game depth)


scoreEachPosition : Int -> Game -> Int -> ScoredPosition
scoreEachPosition position game depth =
    let
        newGame =
            nextMove position game
    in
    ScoredPosition position (scorePosition newGame depth)


scorePosition : Game -> Int -> Int
scorePosition ({ state, currentPlayer } as newGame) depth =
    case state of
        InProgress ->
            case currentPlayer.typePlayer of
                Just Super ->
                    allPositionsScored newGame (depth + 1)
                        |> highestScore

                _ ->
                    allPositionsScored newGame (depth + 1)
                        |> lowestScore

        Draw ->
            0

        Won player ->
            case player.typePlayer of
                Just Super ->
                    10 - depth

                _ ->
                    depth - 10

        NewGame ->
            0


highestScore : List ScoredPosition -> Int
highestScore positionsScores =
    positionsScores
        |> ElmList.maximumBy (\{ position, score } -> score)
        |> Maybe.withDefault (ScoredPosition 0 0)
        |> .score


lowestScore : List ScoredPosition -> Int
lowestScore positionsScores =
    positionsScores
        |> ElmList.minimumBy (\{ position, score } -> score)
        |> Maybe.withDefault (ScoredPosition 0 0)
        |> .score
