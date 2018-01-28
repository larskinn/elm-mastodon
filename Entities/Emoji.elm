module Entities.Emoji exposing (Emoji, decodeEmoji)

import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias Emoji =
    { shortcode : String
    , url : String
    , staticUrl : String

    -- visible_in_picker is not mentioned in the API docs, but is included in the response
    -- visibleInPicker : Bool
    }


decodeEmoji : Decoder Emoji
decodeEmoji =
    decode Emoji
        |> required "shortcode" string
        |> required "url" string
        |> required "static_url" string
