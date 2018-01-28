module Entities.AccountTests exposing (..)

import Entities.Account exposing (AccountWithSource, decodeAccountWithSource)
import Expect
import Json.Decode exposing (decodeString)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "The Entities.Account module"
        [ describe "decodeAccountWithSource"
            [ test "should succeed on a valid response from /api/v1/accounts/verify_credentials" <|
                \_ ->
                    case decodeString decodeAccountWithSource accountWithSourceField of
                        Ok _ ->
                            Expect.pass

                        Err err ->
                            Expect.fail err
            ]
        ]


accountWithSourceField : String
accountWithSourceField =
    """
    {
        "id": "12345",
        "username": "exampleuser",
        "acct": "exampleuser",
        "display_name": "Example User has Emoji 💾",
        "locked": false,
        "created_at": "2018-01-12T14:43:27.452Z",
        "note": "<p>I am an example &amp; my bio looks like this</p>",
        "url": "https://mastodon.example.com/@exampleuser",
        "avatar": "https://cdn.example.com/avatars/original/example.png",
        "avatar_static": "https://cdn.example.com/avatars/original/example.png",
        "header": "https://mastodon.example.com/headers/original/missing.png",
        "header_static": "https://mastodon.example.com/headers/original/missing.png",
        "followers_count": 20,
        "following_count": 40,
        "statuses_count": 205,
        "source": {
            "privacy": "public",
            "sensitive": false,
            "note": "I am an example & my bio looks like this"
        }
    }
    """
