module Commands exposing (..)

import Http
import HttpBuilder exposing (request, withExpect, withHeaders, withJsonBody)
import Json.Decode exposing (Decoder, at, bool, field, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, optional, required, requiredAt)
import Json.Encode as Encode


baseUrl : String
baseUrl =
    "https://api.spacetraders.io/v2/"


token =
    "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmaWVyIjoiVEVBTS1SRUQiLCJ2ZXJzaW9uIjoidjIiLCJyZXNldF9kYXRlIjoiMjAyMy0wNi0yNCIsImlhdCI6MTY4ODExMTU4MCwic3ViIjoiYWdlbnQtdG9rZW4ifQ.bpnSE-hd8jNY9k4pZ0XnmubAOLpYX-y00yjIwoqvKiYA90E2pk-ctBW4BXCyTBko6dB7lpq62N-VacDcIGXEEefy2Uea-yJT6FubOX_SL2DrVDSRu5vZm3GifGrWDoHanuKd-SAQkA5AruaYd0iny5amW4E9RsMlfldB_J2KaO3IQ_cbxxbGUsJeIZr66SaXvds2F68eoUUfk5vJXBcdbXRmzggC0IyjyeZJLwnxvREhO5lnoKKbVr4qswfswkMwMcsYzzl56pf20QdHzxQXtumRj0CUfO6qyrxB3Bz8VJ5Caw6j9wtHJUl0huC1EbwlrpHsv1oUd9QsR9_YyuG5Bg"



--{"data":[{"symbol":"COSMIC","reputation":100}],"meta":{"total":1,"page":1,"limit":10}}


type alias Faction =
    { symbol : String
    , reputation : Int
    }


factionDecoder : Decoder Faction
factionDecoder =
    succeed Faction
        |> required "symbol" string
        |> required "reputation" int


factionListDecoder : Decoder (List Faction)
factionListDecoder =
    field "data" (list factionDecoder)


getFactions : (Result Http.Error (List Faction) -> msg) -> Cmd msg
getFactions msg =
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
        |> withHeaders [ ( "Content-Type", "application/json" ) ]
        |> withExpect (Http.expectJson msg (at [ "data", "token" ] string))
        |> withJsonBody payload
        |> request
