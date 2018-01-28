module Entities.CardTests exposing (..)

import Entities.Card exposing (Card, decodeCard)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.Card module"
        [ describe "decodeCard"
            [ test "should succeed on JSON for a card with type: 'link'" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeCard linkCardJson
            , test "should succeed on JSON for a card with type: 'video'" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeCard videoCardJson

            {- TODO Find examples of toots with preview cards of types 'photo' and 'rich' -}
            ]
        ]


linkCardJson : String
linkCardJson =
    """
{
    "url": "https://emojipedia.org/face-with-rolling-eyes/",
    "title": "\x1F644 Face With Rolling Eyes Emoji",
    "description": "A face displaying eyes glancing upward, indicating an eye-roll. This is used to show disdain, contempt or boredom about a person or topic. Confusingly, this is shown as a happy side-glance…",
    "type": "link",
    "author_name": "",
    "author_url": "",
    "provider_name": "",
    "provider_url": "",
    "html": "",
    "width": 400,
    "height": 214,
    "image": "https://cdn.example.com/preview_cards/images/original/ab7ed04bfa06331c.png",
    "embed_url": ""
}
"""


videoCardJson : String
videoCardJson =
    """
{
    "url": "https://www.youtube.com/watch?v=pRQg7QbMy8Q",
    "title": "3D Atlas 97 intro and short clip",
    "description": "",
    "type": "video",
    "author_name": "Rebellious Treecko",
    "author_url": "https://www.youtube.com/user/RebelliousGrovyle",
    "provider_name": "YouTube",
    "provider_url": "https://www.youtube.com/",
    "html": "<iframe width=\\"480\\" height=\\"270\\" src=\\"https://www.youtube.com/embed/pRQg7QbMy8Q?feature=oembed\\" frameborder=\\"0\\" allowfullscreen=\\"\\"></iframe>",
    "width": 480,
    "height": 270,
    "image": null,
    "embed_url": ""
}
"""
