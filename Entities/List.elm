module Entities.List exposing (ListInfo, decodeListInfo)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias ListInfo =
    { id : String
    , title : String
    }


decodeListInfo : Decoder ListInfo
decodeListInfo =
    decode ListInfo
        |> required "id" string
        |> required "title" string
