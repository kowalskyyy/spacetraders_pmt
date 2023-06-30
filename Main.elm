module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, h2, img, input, label, text)
import Html.Attributes exposing (class, placeholder, src, style)
import Html.Events exposing (onClick, onInput)



-- Model


type alias Model =
    { username : String
    , accessToken : String
    , gameData : GameData
    , currentView : String
    }


type alias GameData =
    { credits : Int
    , loans : Loan
    }


type alias Loan =
    { loanName : String
    , loanValue : Int
    }


init : Model
init =
    let
        data =
            { credits = 0
            , loans = loanDefault
            }

        loanDefault =
            { loanName = ""
            , loanValue = 100
            }
    in
    { username = ""
    , accessToken = ""
    , gameData = data
    , currentView = "startView"
    }



-- Msg


type Msg
    = SetUsername String
    | Submit
    | ChangeView String
    | Register String
    | Login String



-- Update


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetUsername username ->
            { model | username = username }

        Submit ->
            model

        ChangeView x ->
            { model | currentView = x }

        Register name ->
            model

        Login toke ->
            model



-- View


view : Model -> Html Msg
view model =
    div [ class "page" ]
        [ topBar
        , div [ class "split-view" ]
            [ navigation model
            , case model.currentView of
                "startView" ->
                    startView model

                "dashboard" ->
                    dashboardView model

                "ships" ->
                    text ""

                "loans" ->
                    text ""

                "missions" ->
                    text ""

                "help" ->
                    text ""
            ]
        ]


topBar : Html Msg
topBar =
    div [ class "topbar" ] [ div [ class "logo" ] [ img [ src "logo.png" ] [] ], div [] [ text "this is top shit", button [] [ text "account" ] ] ]


navigation : Model -> Html Msg
navigation model =
    if model.accessToken /= "" then
        div [ class "navbar left-section" ]
            [ button [ onClick (ChangeView "dashboard") ] [ text "Dashboard" ]
            , button [ onClick (ChangeView "ships") ] [ text "Ships" ]
            , button [ onClick (ChangeView "loans") ] [ text "Loans" ]
            , button [ onClick (ChangeView "missions") ] [ text "Missions" ]
            , button [ onClick (ChangeView "help") ] [ text "Help" ]
            ]

    else
        div
            [ class "navbar left-section" ]
            [ button [] [ text "Help" ]
            ]


displayGameData : Model -> Html Msg
displayGameData model =
    div [] [ div [] [ text "Credits: ", text (String.fromInt model.gameData.credits) ], div [] [ text "Loans: ", text model.gameData.loans.loanName, text "value :", text (String.fromInt model.gameData.loans.loanValue) ] ]



-- Main program


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


startView : Model -> Html Msg
startView model =
    div [ class "right-section" ]
        [ h1 [ class "distance" ] [ text "Register User" ]
        , label [ class "distance" ] [ text "Username: " ]
        , input [ placeholder "Enter your username", onInput Register, class "distance" ] []
        , button [ onClick Submit, class "distance" ] [ text "Register" ]
        , h1 [ class "distance" ] [ text "Login" ]
        , label [ class "distance" ] [ text "Access token: " ]
        , input [ placeholder "token", onInput Login, class "distance" ] []
        , button [ onClick Submit, class "distance" ] [ text "Log in" ]
        ]


loansView : Model -> Html Msg
loansView model =
    div [] []


shipsView : Model -> Html Msg
shipsView model =
    div [] []


accountView : Model -> Html Msg
accountView model =
    div [] []


dashboardView : Model -> Html Msg
dashboardView model =
    div [] []
