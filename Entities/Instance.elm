module Entities.Instance exposing (Instance, decodeInstance)

import Json.Decode exposing (Decoder, int, nullable, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias Instance =
    { uri : String
    , title : String
    , description : String
    , email : String
    , version : String
    , urls : InstanceUrls

    -- Undocumented fields
    , stats : InstanceStats
    , thumbnail : Maybe String
    }


decodeInstance : Decoder Instance
decodeInstance =
    decode Instance
        |> required "uri" string
        |> required "title" string
        |> required "description" string
        |> required "email" string
        |> required "version" string
        |> required "urls" decodeInstanceUrls
        -- Undocumented fields
        |> required "stats" decodeInstanceStats
        |> required "thumbnail" (nullable string)


type alias InstanceUrls =
    { streamingApi : String
    }


decodeInstanceUrls : Decoder InstanceUrls
decodeInstanceUrls =
    decode InstanceUrls
        |> required "streaming_api" string


type alias InstanceStats =
    { userCount : Int
    , statusCount : Int
    , domainCount : Int
    }


decodeInstanceStats : Decoder InstanceStats
decodeInstanceStats =
    decode InstanceStats
        |> required "user_count" int
        |> required "status_count" int
        |> required "domain_count" int
