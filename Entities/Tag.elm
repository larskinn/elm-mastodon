module Entities.Tag exposing (Tag, decodeTag)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias Tag =
    { name : String -- The hashtag, not including the preceding #
    , url : String -- The URL of the hashtag
    }


decodeTag : Decoder Tag
decodeTag =
    decode Tag
        |> required "name" string
        |> required "url" string
