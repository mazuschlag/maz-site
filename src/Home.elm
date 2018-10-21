module Home exposing (init, update, view, subscriptions, Model, Msg(..))

import Html exposing (Html, div, h1, button, text, a, p, img)
import Html.Attributes exposing (id, classList, href, target, src)
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
    , resume : String
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
    , info = "My name is Mark Zuschlag, a Software Engineer at "
    , languageText = "日本語"
    , href = "/jp"
    , resume = "Resume"
    , language = Japanese }

toJapanese : Page
toJapanese = 
    { title = "マーク・ズッシュラク | ホーム"
    , greeting = "こんにちは、世界！"
    , info = "でソフトウェアエンジニアのマーク・ズッシュラク"
    , languageText = "English"
    , href = "/"
    , resume = "履歴書(英語)"
    , language = English }

notFound : Page
notFound = 
    { title = "Mark Zuschlag"
    , greeting = "Whoops!"
    , info = "The requested page was not found"
    , languageText = "Home"
    , href = "/"
    , resume = ""
    , language = English }


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
        [ div [ id "pg", classList [ ("page", True) ] ] 
            [ div [ id "content" ] 
                [ img [ src imageLink, classList [("main-img", True)] ] []
                , div [ id "words" ] 
                    [ h1 [ id "greeting" ] [ text model.home.greeting ]
                    , div [ id "infos" ] [ information model ]
                    , div [ id "links" ] 
                        [ a [ href githubLink, target "_blank", classList [ ("info", True), ("link", True), ("magic-underline", True) ] ] [ text "Github" ]
                        , a [ href linkedInLink, target "_blank", classList [ ("info", True), ("link", True), ("magic-underline", True) ] ] [ text "LinkedIn" ]
                        , a [ href resumeLink, target "_blank", classList [ ("info", True), ("link", True), ("magic-underline", True) ] ] [ text model.home.resume ]
                        , a [ href model.home.href, classList [ ("info", True), ("link", True), ("magic-underline", True) ] ] [ text model.home.languageText ]
                        ]
                    ]
                ]
            ]
        ]
    }

information : Model -> Html Msg
information model = 
    case model.home.language of 
        Japanese ->  p [ classList [ ("info", True), ("info-size", True) ] ] (englishInfo model.home.info)
        English -> p [ classList [ ("info", True), ("info-size", True) ] ] (japaneseInfo model.home.info)

englishInfo : String -> List (Html Msg)
englishInfo info = [ text info
                   , a [ href moxiLink
                        , target "_blank"
                        , classList [ ("magic-underline", True), ("info", True), ("moxi-size", True) ]
                        ] [ text "MoxiWorks." ]
                   ]

japaneseInfo : String -> List (Html Msg)
japaneseInfo info = [ a [ href moxiLink
                         , target "_blank"
                         , classList [ ("magic-underline", True), ("info", True), ("moxi-size", True) ]
                         ] [ text "MoxiWorks" ]
                    , text info 
                    ]


moxiLink : String
moxiLink = "https://moxiworks.com/"

githubLink : String
githubLink = "https://github.com/mazuschlag"

linkedInLink : String
linkedInLink = "https://www.linkedin.com/in/mark-zuschlag/"

imageLink : String
imageLink = "/assets/pic2edit.png"

resumeLink : String
resumeLink = "/assets/zuschlag_mark_resume.pdf"