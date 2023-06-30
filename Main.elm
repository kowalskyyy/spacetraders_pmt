module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, h2, input, label, button, text)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onClick, onInput)


-- Model


type alias Model =
    { username : String
    , response : String
    }


init : Model
init =
    { username = ""
    , response = ""
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
