module Entities.EmojiTests exposing (..)

import Entities.Emoji exposing (Emoji, decodeEmoji)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.Emoji module"
        [ describe "decodeEmoji"
            [ test "should succeed on valid emoji JSON" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeEmoji emojiJson
            ]
        ]


emojiJson : String
emojiJson =
    """
    {
        "shortcode": "thumbs_up_hmn_b1",
        "url": "https://cdn.example.com/custom_emojis/images/original/thumbs_up__hmn-b1_.png",
        "static_url": "https://cdn.example.com/custom_emojis/images/static/thumbs_up__hmn-b1_.png",
        "visible_in_picker": true
    }
    """
