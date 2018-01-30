module Entities.Status exposing (Status, decodeStatus)

import Date exposing (Date)
import Entities.Account exposing (Account, decodeAccount)
import Entities.Application exposing (Application, decodeApplication)
import Entities.Attachment exposing (Attachment, decodeAttachment)
import Entities.Emoji exposing (Emoji, decodeEmoji)
import Entities.Mention exposing (Mention, decodeMention)
import Entities.Tag exposing (Tag, decodeTag)
import Entities.Visibility exposing (Visibility, decodeVisibility)
import Internal.Decoding exposing (decodeId)
import Json.Decode as Decode exposing (Decoder, bool, int, list, nullable, string)
import Json.Decode.Extra exposing (date)
import Json.Decode.Pipeline exposing (decode, optional, required)


type alias Status =
    { id : String
    , uri : String -- A Fediverse-unique resource ID
    , url : String -- URL to the status page (can be remote)
    , account : Account -- The Account which posted the status
    , inReplyToId : Maybe String -- The ID of the status it replies to
    , inReplyToAccountId : Maybe String -- The ID of the account it replies to
    , reblog : Maybe Reblog -- The reblogged Status
    , content : String -- Body of the status; this will contain HTML (remote HTML already sanitized)
    , createdAt : Date
    , emojis : List Emoji
    , reblogsCount : Int
    , favouritesCount : Int
    , reblogged : Bool -- Whether the authenticated user has reblogged the status
    , favourited : Bool -- Whether the authenticated user has favourited the status
    , muted : Bool -- Whether the authenticated user has muted the conversation this status from
    , sensitive : Bool -- Whether media attachments should be hidden by default
    , spoilerText : String -- If not empty, warning text that should be displayed before the actual content
    , visibility : Visibility
    , mediaAttachments : List Attachment
    , mentions : List Mention
    , tags : List Tag
    , application : Maybe Application -- Application from which the status was posted
    , language : Maybe String -- The detected language for the status, if detected
    , pinned : Bool -- Whether this is the pinned status for the account that posted it
    }


type Reblog
    = Reblog Status


decodeStatus : Decoder Status
decodeStatus =
    decode Status
        |> required "id" decodeId
        |> required "uri" string
        |> required "url" string
        |> required "account" decodeAccount
        |> required "in_reply_to_id" (nullable decodeId)
        |> required "in_reply_to_account_id" (nullable decodeId)
        |> required "reblog" (nullable decodeReblog)
        |> required "content" string
        |> required "created_at" date
        |> required "emojis" (list decodeEmoji)
        |> required "reblogs_count" int
        |> required "favourites_count" int
        |> optional "reblogged" bool False
        |> optional "favourited" bool False
        |> optional "muted" bool False
        |> required "sensitive" bool
        |> required "spoiler_text" string
        |> required "visibility" decodeVisibility
        |> required "media_attachments" (list decodeAttachment)
        |> required "mentions" (list decodeMention)
        |> required "tags" (list decodeTag)
        |> required "application" (nullable decodeApplication)
        |> required "language" (nullable string)
        |> optional "pinned" bool False


decodeReblog : Decoder Reblog
decodeReblog =
    Decode.map Reblog <| Decode.lazy <| \_ -> decodeStatus
