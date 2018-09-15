module View exposing (view)

import Model exposing (Model)
import Update exposing (Msg(..))
import Html exposing (Html, div, h1, button, text)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)

view : Model -> Html Msg
view model = 
    div [ id "view" ]
        [ button [ onClick English ] [ text "English" ] 
        , h1 [] [ text model ]
        , button [ onClick Japanese ] [ text "Japanese" ]
        ]