import Browser
import Home exposing (init, update, view, subscriptions, Model, Msg(..))

main : Program () Model Msg
main =
    Browser.application 
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }