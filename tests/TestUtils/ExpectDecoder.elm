module TestUtils.ExpectDecoder exposing (toSucceed)

import Expect exposing (Expectation)
import Json.Decode as Decode exposing (Decoder)


toSucceed : Decoder a -> String -> Expectation
toSucceed decoder json =
    case Decode.decodeString decoder json of
        Ok _ ->
            Expect.pass

        Err err ->
            Expect.fail err
