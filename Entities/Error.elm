module Entities.Error exposing (Error, decodeError)

import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias Error =
    { error : String
    }


decodeError : Decoder Error
decodeError =
    decode Error
        |> required "error" string
