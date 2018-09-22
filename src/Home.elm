module Home exposing (init, update, view, subscriptions, Model, Msg(..))

import Html exposing (Html, div, h1, button, text, a, p)
import Html.Attributes exposing (id, classList, href, target)
import Html.Events exposing (onClick)
import Browser.Navigation as Nav
import Debug as Debug
import Browser as Browser
import Url as Url

-- Model
type alias Model = 
    { key : Nav.Key
    , url : Url.Url
    , home : Page
    }

type alias Page = 
    { title : String
    , greeting : String
    , info : String
    , languageText : String
    , href : String
    , language : Language }

type Language = English | Japanese

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key = 
    ( Model key url (loadPage url), Cmd.none )

loadPage : Url.Url -> Page
loadPage url =
    case url.path of 
        "/" -> toEnglish
        "/jp" -> toJapanese
        _ -> notFound 

toLanguage : Page -> Page
toLanguage home =
    case home.language of
        English  -> toJapanese
        Japanese -> toEnglish

toEnglish : Page
toEnglish = 
    { title = "Mark Zuschlag | Home"
    , greeting = "Hello, world!"
    , info = "My name is Mark Zuschlag, a Software Engineer at MoxiWorks"
    , languageText = "日本語"
    , href = "/jp"
    , language = Japanese }

toJapanese : Page
toJapanese = 
    { title = "マーク・ズッシュラク | ホーム"
    , greeting = "こんにちは、世界！"
    , info = "MoxiWorksでソフトウェアエンジニアのマーク・ズッシュラク"
    , languageText = "English"
    , href = "/"
    , language = English }

notFound : Page
notFound = 
    { title = "Mark Zuschlag"
    , greeting = "Whoops!"
    , info = "The requested page was not found"
    , languageText = "日本語"
    , href = "/jp"
    , language = Japanese }


-- Update
type Msg 
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        LinkClicked urlRequest -> 
            case urlRequest of 
                Browser.Internal url ->
                    ( { model | url = url, home = loadPage url } , Nav.pushUrl model.key (Url.toString url) )
                Browser.External href ->
                    ( model, Nav.load href )
        UrlChanged url -> 
            ( { model | url = url, home = loadPage url }, Cmd.none )

            

-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- View
view : Model -> Browser.Document Msg
view model = 
    { title = model.home.title
    , body = 
        [ div [ (id "home"), (classList [ ("page", True) ]) ] 
            [ h1 [] [ text model.home.greeting ]
            , p [] [ text model.home.info ]
            , a [ (href model.home.href) ] [ text ( model.home.languageText ) ]
            , a [ (href githubLink), (target "_blank") ] [ text ( "Github" ) ]
            ]
        ]
    }

githubLink : String
githubLink = "https://github.com/mazuschlag"