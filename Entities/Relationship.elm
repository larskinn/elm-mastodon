module Entities.Relationship exposing (Relationship, decodeRelationship)

import Json.Decode exposing (Decoder, bool, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias Relationship =
    { id : String
    , following : Bool
    , followedBy : Bool
    , blocking : Bool
    , muting : Bool
    , mutingNotifications : Bool
    , requested : Bool
    , domainBlocking : Bool

    -- Undocumented fields
    , showingReblogs : Bool
    }


decodeRelationship : Decoder Relationship
decodeRelationship =
    decode Relationship
        |> required "id" string
        |> required "following" bool
        |> required "followed_by" bool
        |> required "blocking" bool
        |> required "muting" bool
        |> required "muting_notifications" bool
        |> required "requested" bool
        |> required "domain_blocking" bool
        -- Undocumented fields
        |> required "showing_reblogs" bool
