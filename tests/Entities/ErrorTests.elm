module Entities.ErrorTests exposing (..)

import Entities.Error exposing (Error, decodeError)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.Error module"
        [ describe "decodeError"
            [ test "should succeed on valid error JSON" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeError errorJson
            ]
        ]


errorJson : String
errorJson =
    """
    {
        "error": "Record not found"
    }
    """
