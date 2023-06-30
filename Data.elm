module Data exposing (..)

import Date exposing (..)
import Json.Decode as Decode exposing (..)


type alias Model =
    { username : String
    , accessToken : String
    , gameData : GameData
    , inputToken : String
    , currentView : String
    }


type alias GameData =
    { credits : Int
    , agent : Agent
    , faction : Faction
    , contract : Contract
    }


type alias Loan =
    { loanName : String
    , loanValue : Int
    }


type alias Faction =
    { symbol : String
    , reputation : Int
    }


type alias Agent =
    { accountId : String
    , credits : Int
    , headquarters : String
    , startingFaction : String
    , symbol : String
    }


type alias Contract =
    { accepted : Bool
    , deadlineToAccept : Maybe Date
    , expiration : Maybe Date
    , factionSymbol : String
    , fulfilled : Bool
    , id : String
    }


contractInit =
    { accepted = False
    , deadlineToAccept = Nothing
    , expiration = Nothing
    , factionSymbol = ""
    , fulfilled = False
    , id = ""
    }


agentInit =
    { accountId = ""
    , credits = 0
    , headquarters = ""
    , startingFaction = ""
    , symbol = ""
    }


factionInit =
    { symbol = ""
    , reputation = 0
    }
