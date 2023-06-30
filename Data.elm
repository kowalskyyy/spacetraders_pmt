module Data exposing (..)

import Date exposing (..)


type alias Model =
    { username : String
    , accessToken : String
    , gameData : GameData
    , currentView : String
    }


type alias GameData =
    { credits : Int
    , headquarters : String
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
    , deadlineToAccept : Date
    , expiration : Date
    , factionSymbol : String
    , fulfilled : Bool
    , id : String
    }
