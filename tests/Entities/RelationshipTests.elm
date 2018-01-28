module Entities.RelationshipTests exposing (..)

import Entities.Relationship exposing (Relationship, decodeRelationship)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.Relationship module"
        [ describe "decodeRelationship"
            [ test "should succeed on valid relationship JSON" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeRelationship relationshipJson
            ]
        ]


relationshipJson : String
relationshipJson =
    """
    {
        "id": "112233",
        "following": true,
        "showing_reblogs": true,
        "followed_by": true,
        "blocking": false,
        "muting": false,
        "muting_notifications": false,
        "requested": false,
        "domain_blocking": false
    }
    """
