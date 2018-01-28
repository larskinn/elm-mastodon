module Entities.Account exposing (Account, AccountWithSource, decodeAccount, decodeAccountWithSource)

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder, bool, int, nullable, string)
import Json.Decode.Extra exposing (date)
import Json.Decode.Pipeline exposing (decode, optional, required)


type alias Account =
    { id : String
    , username : String
    , acct : String
    , displayName : String
    , locked : Bool
    , createdAt : Date
    , followersCount : Int
    , followingCount : Int
    , statusesCount : Int
    , note : String
    , url : String
    , avatar : String
    , avatarStatic : String
    , header : String
    , headerStatic : String
    , moved : Maybe String
    }


decodeAccount : Decoder Account
decodeAccount =
    decode Account
        |> required "id" string
        |> required "username" string
        |> required "acct" string
        |> required "display_name" string
        |> required "locked" bool
        |> required "created_at" date
        |> required "followers_count" int
        |> required "following_count" int
        |> required "statuses_count" int
        |> required "note" string
        |> required "url" string
        |> required "avatar" string
        |> required "avatar_static" string
        |> required "header" string
        |> required "header_static" string
        |> optional "moved" (nullable string) Nothing


type Privacy
    = Public
    | Unlisted
    | Private
    | Direct


decodePrivacy : Decoder Privacy
decodePrivacy =
    string
        |> Decode.andThen
            (\string ->
                case string of
                    "public" ->
                        Decode.succeed Public

                    "unlisted" ->
                        Decode.succeed Unlisted

                    "private" ->
                        Decode.succeed Private

                    "direct" ->
                        Decode.succeed Direct

                    _ ->
                        Decode.fail "Invalid Privacy"
            )


type alias Source =
    { privacy : Privacy
    , sensitive : Bool
    , note : String
    }


decodeSource : Decoder Source
decodeSource =
    decode Source
        |> required "privacy" decodePrivacy
        |> required "sensitive" bool
        |> required "note" string


type alias WithSource a =
    { a | source : Source }


type alias AccountWithSource =
    WithSource Account


mkAccountWithSource : Account -> Source -> AccountWithSource
mkAccountWithSource account source =
    { source = source
    , id = account.id
    , username = account.username
    , acct = account.acct
    , displayName = account.displayName
    , locked = account.locked
    , createdAt = account.createdAt
    , followersCount = account.followersCount
    , followingCount = account.followingCount
    , statusesCount = account.statusesCount
    , note = account.note
    , url = account.url
    , avatar = account.avatar
    , avatarStatic = account.avatarStatic
    , header = account.header
    , headerStatic = account.headerStatic
    , moved = account.moved
    }


decodeAccountWithSource : Decoder AccountWithSource
decodeAccountWithSource =
    let
        decodeWithSource account =
            Decode.map2 mkAccountWithSource
                (Decode.succeed account)
                (Decode.field "source" decodeSource)
    in
    decodeAccount |> Decode.andThen decodeWithSource
