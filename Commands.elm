module Commands exposing (..)

import Data exposing (..)
import Http
import HttpBuilder exposing (request, withExpect, withHeaders, withJsonBody)
import Json.Decode exposing (Decoder, at, bool, field, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, optional, required, requiredAt)
import Json.Encode as Encode


type alias Res a msg =
    Result Http.Error a -> msg


baseUrl : String
baseUrl =
    "https://api.spacetraders.io/v2/"



--{"data":[{"symbol":"COSMIC","reputation":100}],"meta":{"total":1,"page":1,"limit":10}}


factionListDecoder : Decoder (List Faction)
factionListDecoder =
    field "data" (list factionDecoder)


getFactions : String -> (Result Http.Error (List Faction) -> msg) -> Cmd msg
getFactions token msg =
    HttpBuilder.get (baseUrl ++ "my/factions")
        |> withHeaders [ ( "Content-Type", "application/json" ), ( "Authorization", "Bearer " ++ token ) ]
        |> withExpect (Http.expectJson msg factionListDecoder)
        |> request


registerUser : String -> (Result Http.Error UserRegistration -> msg) -> Cmd msg
registerUser username msg =
    let
        payload =
            Encode.object
                [ ( "symbol", Encode.string username )
                , ( "faction", Encode.string "COSMIC" )
                ]
    in
    HttpBuilder.post (baseUrl ++ "register")
        |> withExpect (Http.expectJson msg (field "data" userRegistrationDecoder))
        |> withJsonBody payload
        |> request


loginUser : String -> (Result Http.Error String -> msg) -> Cmd msg
loginUser token msg =
    HttpBuilder.get (baseUrl ++ "my/agent")
        |> withHeaders [ ( "Content-Type", "application/json" ), ( "Authorization", "Bearer " ++ token ) ]
        |> withExpect (Http.expectJson msg (at [ "data", "user" ] string))
        |> request


getContracts : String -> Res (List Contract) msg -> Cmd msg
getContracts token msg =
    HttpBuilder.get (baseUrl ++ "my/contracts")
        |> withHeaders [ ( "Content-Type", "application/json" ), ( "Authorization", "Bearer " ++ token ) ]
        |> withExpect (Http.expectJson msg (field "data" (list contractDecoder)))
        |> request


acceptContract : String -> String -> Res ContractResult msg -> Cmd msg
acceptContract token contractId msg =
    HttpBuilder.post (baseUrl ++ "my/contracts/" ++ contractId ++ "/accept")
        |> withHeaders [ ( "Content-Type", "application/json" ), ( "Authorization", "Bearer " ++ token ) ]
        |> withExpect (Http.expectJson msg (field "data" contractResultDecoder))
        |> request
