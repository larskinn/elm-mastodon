module Entities.ListTests exposing (..)

import Entities.List exposing (ListInfo, decodeListInfo)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.List module"
        [ describe "decodeListInfo"
            [ test "should succeed on valid list JSON" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeListInfo listJson
            ]
        ]


listJson : String
listJson =
    """
    {
        "id": "11",
        "title": "Test list"
    }
    """
