import Browser
import Home exposing (init, update, view)

main =
    Browser.sandbox { init = init, update = update, view = view }