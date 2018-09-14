module Update exposing (Msg(..), update)

import Model exposing (Model, english, japanese)

type Msg = English | Japanese

update : Msg -> Model -> Model
update msg model =
    case msg of 
        English -> 
            english
        Japanese ->
            japanese
