module Main exposing (..)

import Browser
import Commands exposing (..)
import Data exposing (..)
import Html exposing (Html, button, div, h1, h2, img, input, label, text)
import Html.Attributes exposing (class, placeholder, src, style)
import Html.Events exposing (onClick, onInput)
import Http



-- Model
-- Main program


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = \_ -> Sub.batch [] }


init : flags -> ( Model, Cmd Msg )
init _ =
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
    ( { username = ""
      , accessToken = ""
      , gameData = data
      , currentView = "startView"
      }
    , Cmd.none
    )



-- Msg


type Msg
    = SetUsername String
    | Submit
    | ChangeView String
    | Login String
    | GetFactions (Result Http.Error (List Faction))
    | RegisterUser (Result Http.Error String)



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        SetUsername username ->
            ( { model | username = username }, Cmd.none )

        Submit ->
            ( model, Commands.registerUser model.username RegisterUser )

        ChangeView x ->
            ( { model | currentView = x }, Cmd.none )

        Login toke ->
            ( model, Cmd.none )

        GetFactions (Ok x) ->
            ( model, Cmd.none )

        GetFactions (Err e) ->
            ( model, Cmd.none )

        RegisterUser (Ok x) ->
            ( { model | accessToken = x, currentView = "dashboard" }, Commands.getFactions GetFactions )

        RegisterUser (Err e) ->
            ( model, Cmd.none )



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

                _ ->
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


startView : Model -> Html Msg
startView model =
    div [ class "right-section" ]
        [ h1 [ class "distance" ] [ text "Register User" ]
        , label [ class "distance" ] [ text "Username: " ]
        , input [ placeholder "Enter your username", onInput SetUsername, class "distance" ] []
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
