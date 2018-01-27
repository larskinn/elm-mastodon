module Entities.Attachment exposing (Attachment, decodeAttachment)

import Json.Decode as Decode exposing (Decoder, float, int, nullable, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias Attachment =
    { id : Int
    , attachmentType : AttachmentType
    , url : String
    , remoteUrl : Maybe String
    , previewUrl : String
    , textUrl : Maybe String
    , meta : Maybe AttachmentMeta
    , description : Maybe String
    }


decodeAttachment : Decoder Attachment
decodeAttachment =
    decode Attachment
        |> required "id" int
        |> required "type" decodeAttachmentType
        |> required "url" string
        |> required "remote_url" (nullable string)
        |> required "preview_url" string
        |> required "text_url" (nullable string)
        |> required "meta" (nullable decodeAttachmentMeta)
        |> required "description" (nullable string)


type AttachmentType
    = ImageAttachment
    | VideoAttachment
    | GifvAttachment
    | UnknownAttachment


decodeAttachmentType : Decoder AttachmentType
decodeAttachmentType =
    string
        |> Decode.andThen
            (\string ->
                case string of
                    "ImageAttachment" ->
                        Decode.succeed ImageAttachment

                    "VideoAttachment" ->
                        Decode.succeed VideoAttachment

                    "GifvAttachment" ->
                        Decode.succeed GifvAttachment

                    "UnknownAttachment" ->
                        Decode.succeed UnknownAttachment

                    _ ->
                        Decode.fail "Invalid AttachmentType"
            )


type alias AttachmentMeta =
    { small : AttachmentMetaInfo
    , original : AttachmentMetaInfo
    }


decodeAttachmentMeta : Decoder AttachmentMeta
decodeAttachmentMeta =
    decode AttachmentMeta
        |> required "small" decodeAttachmentMetaInfo
        |> required "original" decodeAttachmentMetaInfo


type alias AttachmentMetaInfo =
    { width : Int
    , height : Int
    , size : String
    , aspect : Float
    }


decodeAttachmentMetaInfo : Decoder AttachmentMetaInfo
decodeAttachmentMetaInfo =
    decode AttachmentMetaInfo
        |> required "width" int
        |> required "height" int
        |> required "size" string
        |> required "aspect" float
