module Mark exposing (Mark(..), showMark)

-- TYPE


type Mark
    = X
    | O
    | Empty



-- SHOW


showMark : Mark -> String
showMark mark =
    case mark of
        X ->
            "X"

        O ->
            "O"

        Empty ->
            ""
