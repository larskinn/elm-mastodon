module Entities.ApplicationTests exposing (..)

import Entities.Application exposing (Application, decodeApplication)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.Application module"
        [ describe "decodeApplication"
            [ test "should succeed on valid application JSON" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeApplication applicationExample
            ]
        ]


applicationExample : String
applicationExample =
    """
    {
        "name": "Web",
        "website": null
    }
    """
