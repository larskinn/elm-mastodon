module Entities.InstanceTests exposing (..)

import Entities.Instance exposing (Instance, decodeInstance)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.Instance module"
        [ describe "decodeInstance"
            [ test "should succeed on valid instance JSON" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeInstance instanceExample
            ]
        ]


instanceExample : String
instanceExample =
    """
    {
        "uri": "mastodon.social",
        "title": "Mastodon",
        "description": "This page describes the mastodon.social <em>instance</em> - wondering what Mastodon is? Check out <a href=\\"https://joinmastodon.org\\">joinmastodon.org</a> instead! In essence, Mastodon is a decentralized, open source social network. This is just one part of the network, run by the main developers of the project <img draggable=\\"false\\" alt=\\"🐘\\" class=\\"emojione\\" src=\\"https://mastodon.social/emoji/1f418.svg\\" /> It is not focused on any particular niche interest - everyone is welcome as long as you follow our code of conduct!",
        "email": "eugen@zeonfederated.com",
        "version": "2.2.0rc2",
        "urls": {
            "streaming_api": "wss://mastodon.social"
        },
        "stats": {
            "user_count": 126304,
            "status_count": 4280085,
            "domain_count": 3706
        },
        "thumbnail": "https://files.mastodon.social/site_uploads/files/000/000/001/original/DN5wMUeVQAENPwp.jpg_large.jpeg"
    }
    """
