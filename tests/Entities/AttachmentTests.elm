module Entities.AttachmentTests exposing (..)

import Entities.Attachment exposing (Attachment, decodeAttachment)
import Test exposing (Test, describe, test)
import TestUtils.ExpectDecoder as ExpectDecoder


suite : Test
suite =
    describe "The Entities.Attachment module"
        [ describe "decodeAttachment"
            [ test "should succeed on valid attachment JSON" <|
                \_ ->
                    ExpectDecoder.toSucceed decodeAttachment attachmentExample
            ]
        ]


attachmentExample : String
attachmentExample =
    """
  {
    "id": "234567",
    "type": "image",
    "url": "https://cdn.example.com/original/e776249e3d698eb1.jpeg",
    "preview_url": "https://cdn.example.com/small/e776249e3d698eb1.jpeg",
    "remote_url": null,
    "text_url": "https://mastodon.example.com/media/m5iNjYF-SyDmu37oaMU",
    "meta": {
      "original": {
        "width": 700,
        "height": 700,
        "size": "700x700",
        "aspect": 1.0
      },
      "small": {
        "width": 400,
        "height": 400,
        "size": "400x400",
        "aspect": 1.0
      }
    },
    "description": null
  }
    """
