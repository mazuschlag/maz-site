module Home exposing (init, update, view)

import Html exposing (Html, div, h1, button, text, a, p)
import Html.Attributes exposing (id, classList, href, target)
import Html.Events exposing (onClick)

-- Model
type alias Model = 
    { greeting : String
    , info : String
    , btnText : String
    , githubText : String
    , isEnglish : Bool }

init : Model
init = toEnglish

language : Model -> Model
language model =
    case model.isEnglish of
        True  -> toJapanese
        False -> toEnglish

toEnglish : Model
toEnglish = { greeting = "Hello, world!"
            , info = "My name is Mark Zuschlag, a Software Engineer at MoxiWorks"
            , btnText = "日本語"
            , githubText = "Github"
            , isEnglish = True }

toJapanese : Model
toJapanese = { greeting = "こんにちは、世界！"
             , info = "MoxiWorksでソフトウェアエンジニアのマーク・ズッシュラク"
             , btnText = "English"
             , githubText = "Github"
             , isEnglish = False }

-- Update
type Msg = Language | Github

update : Msg -> Model -> Model
update msg model =
    case msg of 
        Language -> 
            language model
        Github ->
            model

-- View
view : Model -> Html Msg
view model = 
    div [ (id "home"), (classList [ ("page", True) ]) ] 
        [ h1 [] [ text model.greeting ]
        , p [] [ text model.info ]
        , button [ onClick Language ] [ text ( model.btnText ) ]
        , a [ (href githubLink), (target "_blank") ] [ text ( model.githubText ) ]
        ]

githubLink : String
githubLink = "https://github.com/mazuschlag"