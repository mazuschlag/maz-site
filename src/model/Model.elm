module Model exposing (Model, init, english, japanese)

type alias Model = String

init : Model
init = english

english : Model
english = "Hello world!"

japanese : Model
japanese = "こんにちは、世界！"