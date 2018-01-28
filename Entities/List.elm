module Entities.List exposing (ListInfo, decodeListInfo)

import Internal.Decoding exposing (decodeId)
import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias ListInfo =
    { id : String
    , title : String
    }


decodeListInfo : Decoder ListInfo
decodeListInfo =
    decode ListInfo
        |> required "id" decodeId
        |> required "title" string
