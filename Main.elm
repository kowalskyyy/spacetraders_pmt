module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, h2, input, label, text)
import Html.Attributes exposing (class, placeholder, style)
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
    , accessToken = "et"
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
    div [ class "split-view" ]
        [ navigation
        , case model.currentView of
            "startView" ->
                startView model

            _ ->
                text ""
        ]


navigation : Html Msg
navigation =
    div [ class "navbar left-section" ]
        [ button [] [ text "Dashboard" ]
        , button [] [ text "Ships" ]
        , button [] [ text "Loans" ]
        , button [] [ text "Missions" ]
        , button [] [ text "Something else" ]
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
        [ h1 [] [ text "Register User" ]
        , label [] [ text "Username: " ]
        , input [ placeholder "Enter your username", onInput Register ] []
        , button [ onClick Submit ] [ text "Register" ]
        , h1 [] [ text "Login" ]
        , label [] [ text "Access token: " ]
        , input [ placeholder "token", onInput Login ] []
        , button [ onClick Submit ] [ text "Log in" ]
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
