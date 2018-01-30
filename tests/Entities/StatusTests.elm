module Entities.StatusTests exposing (..)

import Entities.Status exposing (decodeStatus)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.Status module"
        [ describe "decodeStatus"
            [ test "should succeed on a non-authenticated status response" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeStatus nonAuthedStatusJson
            ]
        ]


nonAuthedStatusJson : String
nonAuthedStatusJson =
    """
{
        "id": "99440552721575591",
        "created_at": "2018-01-30T20:00:18.309Z",
        "in_reply_to_id": null,
        "in_reply_to_account_id": null,
        "sensitive": false,
        "spoiler_text": "",
        "visibility": "public",
        "language": "en",
        "uri": "https://mastodon.technology/users/GodotEngineBot/statuses/99440552633280446",
        "content": "<p>Finished up my first <a href=\\"https://mastodon.technology/tags/1gam\\" class=\\"mention hashtag\\" rel=\\"nofollow noopener\\" target=\\"_blank\\">#<span>1GAM</span></a>: <a href=\\"https://gumballstudios.itch.io/schooled\\" rel=\\"nofollow noopener\\" target=\\"_blank\\"><span class=\\"invisible\\">https://</span><span class=\\"ellipsis\\">gumballstudios.itch.io/schoole</span><span class=\\"invisible\\">d</span></a> . Now to grab <a href=\\"https://mastodon.technology/tags/godotengine\\" class=\\"mention hashtag\\" rel=\\"nofollow noopener\\" target=\\"_blank\\">#<span>GodotEngine</span></a> 3.0 for the other 11. <a href=\\"https://mastodon.technology/tags/gamedev\\" class=\\"mention hashtag\\" rel=\\"nofollow noopener\\" target=\\"_blank\\">#<span>gamedev</span></a> <a href=\\"https://twitter.com/cravipat/status/958426302343720960\\" rel=\\"nofollow noopener\\" target=\\"_blank\\"><span class=\\"invisible\\">https://</span><span class=\\"ellipsis\\">twitter.com/cravipat/status/95</span><span class=\\"invisible\\">8426302343720960</span></a></p>",
        "url": "https://mastodon.technology/@GodotEngineBot/99440552633280446",
        "reblogs_count": 1,
        "favourites_count": 0,
        "reblog": null,
        "application": null,
        "account": {
            "id": "16284",
            "username": "GodotEngineBot",
            "acct": "GodotEngineBot@mastodon.technology",
            "display_name": "Godot Engine [BOT]",
            "locked": false,
            "created_at": "2017-07-06T15:06:09.383Z",
            "note": "<p>Replicator of Twitter tweets related to the greatest game engine ever, Godot Engine.</p>",
            "url": "https://mastodon.technology/@GodotEngineBot",
            "avatar": "https://cdn.example.com/accounts/avatars/000/016/284/original/5e2eae1071cc92fe.png",
            "avatar_static": "https://cdn.example.com/accounts/avatars/000/016/284/original/5e2eae1071cc92fe.png",
            "header": "https://mastodon.example.com/headers/original/missing.png",
            "header_static": "https://mastodon.example.com/headers/original/missing.png",
            "followers_count": 224,
            "following_count": 0,
            "statuses_count": 3260
        },
        "media_attachments": [],
        "mentions": [],
        "tags": [
            {
                "name": "1gam",
                "url": "https://mastodon.example.com/tags/1gam"
            },
            {
                "name": "godotengine",
                "url": "https://mastodon.example.com/tags/godotengine"
            },
            {
                "name": "gamedev",
                "url": "https://mastodon.example.com/tags/gamedev"
            }
        ],
        "emojis": []
    }
    """
