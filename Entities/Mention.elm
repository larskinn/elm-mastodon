module Entities.Mention exposing (Mention, decodeMention)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias Mention =
    { url : String
    , username : String
    , acct : String
    , id : String
    }


decodeMention : Decoder Mention
decodeMention =
    decode Mention
        |> required "url" string
        |> required "username" string
        |> required "acct" string
        |> required "id" string
