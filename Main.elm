module Main exposing (..)

import Browser
import Commands exposing (..)
import Data exposing (..)
import Html exposing (Html, button, div, h1, h2, img, input, label, section, text)
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
            , agent = agentInit
            , faction = factionInit
            , contracts = []
            , ship = initShip
            }

        loanDefault =
            { loanName = ""
            , loanValue = 100
            }
    in
    ( { username = ""
      , accessToken = ""
      , inputToken = ""
      , gameData = data
      , currentView = "startView"
      , acceptedContracts = []
      }
    , Cmd.none
    )



-- Msg


type Msg
    = SetUsername String
    | Submit
    | ChangeView String
    | LoginInput String
    | Logout
    | Login
    | GetFactions (Result Http.Error (List Faction))
    | RegisterUser (Result Http.Error UserRegistration)
    | LoginUser (Result Http.Error String)
    | Contracts (Result Http.Error (List Contract))
    | AcceptContract (Result Http.Error ContractResult)



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

        Login ->
            ( model, Commands.loginUser model.inputToken LoginUser )

        LoginInput x ->
            ( { model | inputToken = x }, Cmd.none )

        GetFactions (Ok x) ->
            ( model, Cmd.none )

        GetFactions (Err e) ->
            ( model, Cmd.none )

        RegisterUser (Ok x) ->
            let
                gd : GameData
                gd =
                    { credits = x.agent.credits
                    , agent = x.agent
                    , contracts = [ x.contract ]
                    , faction = x.faction
                    , ship = x.ship
                    }
            in
            ( { model
                | accessToken = x.token
                , gameData = gd
                , currentView = "dashboard"
              }
            , Cmd.none
            )

        RegisterUser (Err e) ->
            ( model, Cmd.none )

        LoginUser (Ok x) ->
            ( { model | currentView = "dashboard" }, Cmd.none )

        LoginUser (Err e) ->
            ( model, Cmd.none )

        Logout ->
            ( { model | accessToken = "", currentView = "startView" }, Cmd.none )

        Contracts (Ok x) ->
            let
                gd =
                    model.gameData

                ngd =
                    { gd | contracts = x }
            in
            ( { model | gameData = ngd }, Cmd.none )

        Contracts (Err e) ->
            ( model, Cmd.none )

        AcceptContract (Ok x) ->
            ( { model | acceptedContracts = x :: model.acceptedContracts }, Cmd.none )

        AcceptContract (Err e) ->
            ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div [ class "page", src "background.png" ]
        [ topBar model
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


topBar : Model -> Html Msg
topBar model =
    if model.currentView == "startView" then
        text ""

    else
        div [ class "topbar" ]
            [ div [ class "logo" ] [ img [ src "logo.png" ] [] ]
            , div [] [ button [ onClick Logout ] [ text "Logout" ] ]
            ]


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
        text ""


displayGameData : Model -> Html Msg
displayGameData model =
    div [] []


startView : Model -> Html Msg
startView model =
    div []
        [ img [ src "logo.png", class "logobig" ] []
        , div [ class "description" ] [ text "Manage a fleet of ships, automate trade routes, discover hidden secrets in the universe and more. Play/Build now!" ]
        , div [ class "right-section" ]
            [ div [ class "form" ]
                [ h1 [ class "distance" ] [ text "Register User" ]
                , label [ class "distance" ] [ text "Username: " ]
                , input [ placeholder "Enter your username", onInput SetUsername, class "distance" ] []
                , button [ onClick Submit, class "distance" ] [ text "Register" ]
                ]
            , div [ style "padding" "2vh" ] [ text "OR" ]
            , div [ class "form" ]
                [ h1 [ class "distance" ] [ text "Login" ]
                , label [ class "distance" ] [ text "Access token: " ]
                , input [ placeholder "token", onInput LoginInput, class "distance" ] []
                , button [ onClick Login, class "distance" ] [ text "Log in" ]
                ]
            ]
        ]


loansView : Model -> Html Msg
loansView model =
    div [] []


shipsView : Model -> Html Msg
shipsView model =
    div [ class "right-section" ] [ text "Ships: " ]


accountView : Model -> Html Msg
accountView model =
    div [] []


dashboardView : Model -> Html Msg
dashboardView model =
    div [ class "right-section" ] [ div [ class "account-details" ] [ section [ class "rotate", style "width" "25vh" ] [ img [ src "rocket.png" ] [] ], section [] [ text ("Username: " ++ model.username) ], section [] [ text ("Access token: " ++ model.accessToken) ], section [] [ text ("Credits: " ++ String.fromInt model.gameData.credits) ] ] ]
