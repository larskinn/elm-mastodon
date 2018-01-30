module Entities.Visibility exposing (Visibility, decodeVisibility)

import Json.Decode as Decode exposing (Decoder, string)


type Visibility
    = Public
    | Unlisted
    | Private
    | Direct


decodeVisibility : Decoder Visibility
decodeVisibility =
    string
        |> Decode.andThen
            (\string ->
                case string of
                    "public" ->
                        Decode.succeed Public

                    "unlisted" ->
                        Decode.succeed Unlisted

                    "private" ->
                        Decode.succeed Private

                    "direct" ->
                        Decode.succeed Direct

                    _ ->
                        Decode.fail "Invalid Visibility"
            )
