module Internal.Decoding exposing (decodeId)

import Json.Decode as Decode exposing (Decoder, int, oneOf, string)


{-| Decode a Mastodon id (int or string) to a string.
Mastodon changed the representation of ids from integer to string in version 2.0.0.
See <https://github.com/tootsuite/mastodon/releases/tag/v2.0.0>
-}
decodeId : Decoder String
decodeId =
    oneOf [ string, Decode.map toString int ]
