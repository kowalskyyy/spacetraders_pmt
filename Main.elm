module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, h2, input, label, text)
import Html.Attributes exposing (placeholder)
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



-- View


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Register User" ]
        , label [] [ text "Username: " ]
        , input [ placeholder "Enter your username", onInput SetUsername ] []
        , button [ onClick Submit ] [ text "Register" ]
        , h2 [] [ text "Response: " ]
        , div [] [ text model.username ]
        , div [] [ text "Access token: ", text model.accessToken ]
        , if model.accessToken /= "" then
            displayGameData model

          else
            text ""
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
    div []
        [ h1 [] [ text "Register User" ]
        , label [] [ text "Username: " ]
        , input [ placeholder "Enter your username", onInput SetUsername ] []
        , button [ onClick Submit ] [ text "Register" ]
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
