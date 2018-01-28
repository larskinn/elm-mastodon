module Entities.ApplicationTests exposing (..)

import Entities.Application exposing (Application, decodeApplication)
import Expect
import Json.Decode exposing (decodeString)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "The Entities.Application module"
        [ describe "decodeApplication"
            [ test "should succeed on valid application JSON" <|
                \_ ->
                    case decodeString decodeApplication applicationExample of
                        Ok _ ->
                            Expect.pass

                        Err err ->
                            Expect.fail err
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
