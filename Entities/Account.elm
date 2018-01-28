module Entities.Account exposing (Account, decodeAccount)

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
