module Player exposing (Player, TypePlayer(..), init)


type TypePlayer
    = Human
    | Random
    | Super


type alias Player =
    { mark : String
    , typePlayer : Maybe TypePlayer
    }


init : TypePlayer -> Player -> Player
init playerType player =
    case playerType of
        Human ->
            { player | typePlayer = Just Human }

        Random ->
            { player | typePlayer = Just Random }

        Super ->
            { player | typePlayer = Just Super }
