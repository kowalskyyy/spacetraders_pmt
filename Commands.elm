module Commands exposing (..)

import Data exposing (..)
import Http
import HttpBuilder exposing (request, withExpect, withHeaders, withJsonBody)
import Json.Decode exposing (Decoder, at, bool, field, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, optional, required, requiredAt)
import Json.Encode as Encode


baseUrl : String
baseUrl =
    "https://api.spacetraders.io/v2/"



--{"data":[{"symbol":"COSMIC","reputation":100}],"meta":{"total":1,"page":1,"limit":10}}


factionDecoder : Decoder Faction
factionDecoder =
    succeed Faction
        |> required "symbol" string
        |> required "reputation" int


factionListDecoder : Decoder (List Faction)
factionListDecoder =
    field "data" (list factionDecoder)


getFactions : String -> (Result Http.Error (List Faction) -> msg) -> Cmd msg
getFactions token msg =
    HttpBuilder.get (baseUrl ++ "my/factions")
        |> withHeaders [ ( "Content-Type", "application/json" ), ( "Authorization", "Bearer " ++ token ) ]
        |> withExpect (Http.expectJson msg factionListDecoder)
        |> request


registerUser : String -> (Result Http.Error String -> msg) -> Cmd msg
registerUser username msg =
    let
        payload =
            Encode.object
                [ ( "symbol", Encode.string username )
                , ( "faction", Encode.string "COSMIC" )
                ]
    in
    HttpBuilder.post (baseUrl ++ "register")
        |> withExpect (Http.expectJson msg (at [ "data", "token" ] string))
        |> withJsonBody payload
        |> request


loginUser : String -> (Result Http.Error String -> msg) -> Cmd msg
loginUser token msg =
    HttpBuilder.get (baseUrl ++ "my/agent")
        |> withHeaders [ ( "Content-Type", "application/json" ), ( "Authorization", "Bearer " ++ token ) ]
        |> withExpect (Http.expectJson msg (at [ "data", "user" ] string))
        |> request
