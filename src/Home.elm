module Home exposing (init, update, view, subscriptions, Model, Msg(..))

import Html exposing (Html, div, h1, button, text, a, p, img, span)
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
    , moreInfo : String
    , functionalInfo : String
    , duckInfo : String
    , languageText : String
    , href : String
    , resume : String
    , language : Language }

type Language = English | Japanese | NotFound

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
        NotFound -> toJapanese

toEnglish : Page
toEnglish = 
    { title = "Mark Zuschlag | Home"
    , greeting = "Hello, world!"
    , info = "My name is Mark Zuschlag, a Software Engineer at "
    , moreInfo = ". I love building backend services, experimenting with "
    , functionalInfo = ", and consulting "
    , duckInfo = "."
    , languageText = "日本語"
    , href = "/jp"
    , resume = "Resume"
    , language = Japanese }

toJapanese : Page
toJapanese = 
    { title = "マーク・ズッシュラク | ホーム"
    , greeting = "こんにちは、世界！"
    , info = "でソフトウェアエンジニアのマーク・ズッシュラク。"
    , moreInfo = "バックエンドを作ったり、"
    , functionalInfo = "の実験をしたり、"
    , duckInfo = "と相談してくれたりすることが好きである。"
    , languageText = "English"
    , href = "/"
    , resume = "履歴書"
    , language = English }

notFound : Page
notFound = 
    { title = "Mark Zuschlag"
    , greeting = "Whoops!"
    , info = "The requested page was not found"
    , moreInfo = ""
    , functionalInfo = ""
    , duckInfo = ""
    , languageText = "Home"
    , href = "/"
    , resume = ""
    , language = NotFound }


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
                [ img [ src imageLink, classList [ imageClass model.home.language ] ] []
                , div [ id "words" ] 
                    [ h1 [ id "greeting" ] [ text model.home.greeting ]
                    , div [ id "infos" ] (information model)
                    , div [ id "links" ] (links model)
                    ]
                ]
            ]
        ]
    }

information : Model -> List (Html Msg)
information model = 
    case model.home.language of 
        Japanese ->  [ p [ id "info", classList [ ("info", True), ("info-size", True) ] ] (englishInfo model.home) ]
        English -> [ p [ id "info", classList [ ("info", True), ("info-size", True) ] ] (japaneseInfo model.home) ]
        NotFound -> [ p [ id "info", classList [ ("info", True), ("info-size", True) ] ] (notFoundInfo model.home) ]

links : Model -> List (Html Msg)
links model = 
    case model.home.language of 
        NotFound -> notFoundLinks model
        _ -> normalLinks model

imageClass : Language -> (String, Bool)
imageClass language =
    case language of 
        NotFound -> ("notfound-img", True)
        _ -> ("main-img", True)

englishInfo : Page -> List (Html Msg)
englishInfo page = [ text page.info
                   , a [ href moxiLink
                        , target "_blank"
                        , classList [ ("underline", True), ("magic-underline", True), ("info", True), ("moxi", True) ]
                        ] [ text "MoxiWorks" ]
                   , text page.moreInfo
                   , a [ href functionalLink
                        , target "_blank"
                        , classList [ ("underline", True), ("magic-underline", True), ("info", True), ("functional", True) ] 
                        ] [ text "functional programming"]
                   , text page.functionalInfo
                   , a [ href duckLink
                        , target "_blank"
                        , classList [ ("underline", True), ("magic-underline", True), ("info", True), ("duck", True) ] 
                        ] [ text "rubber ducks"]
                   , text page.duckInfo
                   ]

japaneseInfo : Page -> List (Html Msg)
japaneseInfo page = [ a [ href moxiLink
                         , target "_blank"
                         , classList [ ("underline", True), ("magic-underline", True), ("info", True), ("moxi", True) ]
                         ] [ text "MoxiWorks" ]
                    , text page.info 
                    , text page.moreInfo
                    , a [ href functionalLink
                        , target "_blank"
                        , classList [ ("underline", True), ("magic-underline", True), ("info", True), ("functional", True) ] 
                        ] [ text "関数型プログラミング"]
                   , text page.functionalInfo
                   , a [ href duckLink
                        , target "_blank"
                        , classList [ ("underline", True), ("magic-underline", True), ("info", True), ("duck", True) ] 
                        ] [ text "ラバーダック"]
                   , text page.duckInfo
                   ]

notFoundInfo : Page -> List (Html Msg)
notFoundInfo page = [ text page.info ]

normalLinks : Model -> List (Html Msg)
normalLinks model = [  a [ href emailLink, target "_blank", classList [ ("info", True), ("link", True), ("hover1", True), ("email", True) ] ] 
                        [ span [ classList [ ("hover1-label", True), ("linkedin-label", True) ] ] [ text "Email Me"]
                        ]
                    ,  a [ href githubLink, target "_blank", classList [ ("info", True), ("link", True), ("hover1", True), ("github", True) ] ] 
                        [ span [ classList [ ("hover1-label", True), ("github-label", True) ] ] [ text "Github" ] 
                        ]
                    ,  a [ href linkedInLink, target "_blank", classList [ ("info", True), ("link", True), ("hover1", True), ("linkedin", True) ] ] 
                        [ span [ classList [ ("hover1-label", True), ("linkedin-label", True) ] ] [ text "LinkedIn"]
                        ]
                    , a [ href resumeLink, target "_blank", classList [ ("info", True), ("link", True), ("hover1", True), ("resume", True) ] ] 
                        [ span [ classList [ ("hover1-label", True), ("resume-label", True) ] ] [ text model.home.resume ]
                        ]
                    , a [ href model.home.href, classList [ ("info", True), ("link", True), ("hover1", True), ("language", True) ] ] 
                        [ span [ classList [ ("hover1-label", True), ("language-label", True) ] ] [text model.home.languageText ] 
                        ]
                    ]


notFoundLinks : Model -> List (Html Msg)
notFoundLinks model = [ a [ href githubLink, target "_blank", classList [ ("info", True), ("link", True), ("hover1", True), ("github", True) ] ] 
                        [ span [ classList [ ("hover1-label", True), ("github-label", True) ] ] [ text "Github" ] 
                        ]
                    , a [ href linkedInLink, target "_blank", classList [ ("info", True), ("link", True), ("hover1", True), ("linkedin", True) ] ] 
                        [ span [ classList [ ("hover1-label", True), ("linkedin-label", True) ] ] [ text "LinkedIn"]
                        ]
                    , a [ href model.home.href, classList [ ("info", True), ("link", True), ("hover1", True), ("language", True) ] ] 
                        [ span [ classList [ ("hover1-label", True), ("language-label", True) ] ] [text model.home.languageText ] 
                        ]
                    ]
moxiLink : String
moxiLink = "https://moxiworks.com/"

functionalLink : String
functionalLink = "https://www.haskell.org/"

duckLink : String
duckLink = "https://en.wikipedia.org/wiki/Rubber_duck_debugging"

githubLink : String
githubLink = "https://github.com/mazuschlag"

email : String
emailLink = "mailto: markazuschlag@gmail.com"

linkedInLink : String
linkedInLink = "https://www.linkedin.com/in/mark-zuschlag/"

imageLink : String
imageLink = "zuschlag_mark.png"

resumeLink : String
resumeLink = "zuschlag_mark_resume.pdf"
