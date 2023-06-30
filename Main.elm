module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, h2, input, label, text)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onClick, onInput)



-- Model


type alias Model =
    { username : String
    , response : String
    , accessToken : String
    , gameData : GameData
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
    , response = ""
    , accessToken = ""
    , gameData = data
    }



-- Msg


type Msg
    = SetUsername String
    | Submit



-- Update


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetUsername username ->
            { model | username = username }

        Submit ->
            model



-- View


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Register User" ]
        , label [] [ text "Username:" ]
        , input [ placeholder "Enter your username", onInput SetUsername ] []
        , button [ onClick Submit ] [ text "Register" ]
        , h2 [] [ text "Response:" ]
        , div [] [ text model.response ]
        ]



-- Main program


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }
