module Entities.MentionTests exposing (..)

import Entities.Mention exposing (Mention, decodeMention)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.Mention module"
        [ describe "decodeMention"
            [ test "should succeed on valid mention JSON" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeMention mentionJson
            ]
        ]


mentionJson : String
mentionJson =
    """
    {
        "id": "12345",
        "username": "exampleuser",
        "url": "https://mastodon.example.com/@exampleuser",
        "acct": "exampleuser@mastodon.example.com"
    }
    """
