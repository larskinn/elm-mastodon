module Entities.Application exposing (Application, decodeApplication)

import Json.Decode exposing (Decoder, string, nullable)
import Json.Decode.Pipeline exposing (decode, required)


type alias Application =
    { name : String
    , website : Maybe String
    }


decodeApplication : Decoder Application
decodeApplication =
    decode Application
        |> required "name" string
        |> required "website" (nullable string)
