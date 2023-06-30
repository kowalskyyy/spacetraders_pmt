module Data exposing (..)

import Date exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (hardcoded, optional, required, requiredAt)


type alias Model =
    { username : String
    , accessToken : String
    , gameData : GameData
    , inputToken : String
    , currentView : String
    , acceptedContracts : List ContractResult
    , selectedIndex : Int
    }


type alias GameData =
    { credits : Int
    , agent : Agent
    , faction : Faction
    , contracts : List Contract
    , ship : Ship
    }


type alias Loan =
    { loanName : String
    , loanValue : Int
    }


type alias Faction =
    { symbol : String
    , reputation : Int
    }


factionDecoder : Decoder Faction
factionDecoder =
    succeed Faction
        |> required "symbol" string
        |> optional "reputation" int 0


type alias UserRegistration =
    { token : String
    , agent : Agent
    , contract : Contract
    , faction : Faction
    , ship : Ship
    }


userRegistrationDecoder : Decoder UserRegistration
userRegistrationDecoder =
    succeed UserRegistration
        |> required "token" string
        |> required "agent" agentDecoder
        |> required "contract" contractDecoder
        |> required "faction" factionDecoder
        |> required "ship" shipDecoder


type alias Agent =
    { accountId : String
    , credits : Int
    , headquarters : String
    , startingFaction : String
    , symbol : String
    }


agentDecoder : Decoder Agent
agentDecoder =
    succeed Agent
        |> required "accountId" string
        |> required "credits" int
        |> required "headquarters" string
        |> required "startingFaction" string
        |> required "symbol" string


type alias Contract =
    { accepted : Bool
    , factionSymbol : String
    , type_ : String
    , terms : Terms
    , fulfilled : Bool
    , expiration : String
    , deadlineToAccept : String
    , id : String
    }


contractInit : Contract
contractInit =
    { accepted = False
    , factionSymbol = ""
    , type_ = "unknown"
    , terms = termsInit
    , fulfilled = False
    , expiration = ""
    , deadlineToAccept = ""
    , id = ""
    }


type alias ContractResult =
    { contract : Contract
    , agent : Agent
    }


contractResultDecoder : Decoder ContractResult
contractResultDecoder =
    succeed ContractResult
        |> required "contract" contractDecoder
        |> required "agent" agentDecoder


agentInit : Agent
agentInit =
    { accountId = ""
    , credits = 0
    , headquarters = ""
    , startingFaction = ""
    , symbol = ""
    }


factionInit : Faction
factionInit =
    { symbol = ""
    , reputation = 0
    }


contractDecoder : Decoder Contract
contractDecoder =
    succeed Contract
        |> required "accepted" bool
        |> required "factionSymbol" string
        |> required "type" string
        |> required "terms" termsDecoder
        |> required "fulfilled" bool
        |> required "expiration" string
        |> required "deadlineToAccept" string
        |> required "id" string


type alias Terms =
    { deadline : String
    , deliver : List Deliver
    , payment : Payment
    }


termsInit : Terms
termsInit =
    { deadline = ""
    , deliver = []
    , payment = paymentInit
    }


termsDecoder : Decoder Terms
termsDecoder =
    succeed Terms
        |> required "deadline" string
        |> required "deliver" (list deliverDecoder)
        |> required "payment" paymentDecoder


type alias Deliver =
    { tradeSymbol : String
    , destinationSymbol : String
    , unitsRequired : Int
    , unitsFulfilled : Int
    }


deliverDecoder : Decoder Deliver
deliverDecoder =
    succeed Deliver
        |> required "destinationSymbol" string
        |> required "tradeSymbol" string
        |> required "unitsFulfilled" int
        |> required "unitsRequired" int


type alias Payment =
    { onAccepted : Int
    , onFulfilled : Int
    }


paymentInit : Payment
paymentInit =
    { onAccepted = 0
    , onFulfilled = 0
    }


paymentDecoder : Decoder Payment
paymentDecoder =
    succeed Payment
        |> required "onAccepted" int
        |> required "onFulfilled" int


type alias Ship =
    { cargo : Cargo

    -- , symbol : String
    -- , nav : Nav
    -- , crew : Crew
    -- , fuel : Fuel
    -- , frame : Frame
    -- , reactor : Reactor
    -- , engine : Engine
    -- , modules : Array Module
    -- , mounts : Array Mount
    -- , registration : Registration
    }


initShip : Ship
initShip =
    { cargo = initCargo }


shipDecoder : Decoder Ship
shipDecoder =
    succeed Ship
        |> required "cargo" cargoDecoder



-- |> required "crew" ShipCrewDecoder
-- |> required "engine" ShipEngineDecoder
-- |> required "frame" ShipFrameDecoder
-- |> required "fuel" ShipFuelDecoder
-- |> required "modules" (list ShipModulesItemDecoder)
-- |> required "mounts" (list ShipMountsItemDecoder)
-- |> required "nav" ShipNavDecoder
-- |> required "reactor" ShipReactorDecoder
-- |> required "registration" ShipRegistrationDecoder
-- |> required "symbol" string


type alias Cargo =
    { capacity : Int
    , units : Int
    , inventory : List ()
    }


initCargo : Cargo
initCargo =
    { capacity = 0
    , units = 0
    , inventory = []
    }


cargoDecoder : Decoder Cargo
cargoDecoder =
    succeed Cargo
        |> required "capacity" int
        |> required "units" int
        |> required "inventory" (list <| succeed ())


type alias Crew =
    { current : Int
    , capacity : Int
    , required : Int
    , rotation : String
    , morale : Int
    , wages : Int
    }


type alias Engine =
    { symbol : String
    , name : String
    , description : String
    , condition : Int
    , speed : Int
    , requirements : EngineRequirements
    }


type alias EngineRequirements =
    { power : Int
    , crew : Int
    }


type alias Frame =
    { symbol : String
    , name : String
    , description : String
    , moduleSlots : Int
    , mountingPoints : Int
    , fuelCapacity : Int
    , condition : Int
    , requirements : EngineRequirements
    }


type alias Fuel =
    { current : Int
    , capacity : Int
    , consumed : Consumed
    }


type alias Consumed =
    { amount : Int
    , timestamp : String
    }


type alias Module =
    { symbol : String
    , name : String
    , description : String
    , capacity : Maybe Int
    , requirements : ModuleRequirements
    , range : Maybe Int
    }


type alias ModuleRequirements =
    { crew : Int
    , power : Int
    , slots : Int
    }


type alias Mount =
    { symbol : String
    , name : String
    , description : String
    , strength : Int
    , requirements : EngineRequirements
    , deposits : List String
    }


type alias Nav =
    { systemSymbol : String
    , waypointSymbol : String
    , route : Route
    , status : String
    , flightMode : String
    }


type alias Route =
    { departure : Departure
    , destination : Departure
    , arrival : String
    , departureTime : String
    }


type alias Departure =
    { symbol : String
    , departureType : String
    , systemSymbol : String
    , x : Int
    , y : Int
    }


type alias Reactor =
    { symbol : String
    , name : String
    , description : String
    , condition : Int
    , powerOutput : Int
    , requirements : ReactorRequirements
    }


type alias ReactorRequirements =
    { crew : Int
    }


type alias Registration =
    { name : String
    , factionSymbol : String
    , role : String
    }
