module Entities.Card exposing (Card, decodeCard)

import Json.Decode as Decode exposing (Decoder, int, nullable, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias Card =
    { url : String
    , title : String
    , description : String
    , image : Maybe String
    , cardType : CardType

    -- OEmbed data
    , authorName : Maybe String
    , authorUrl : Maybe String
    , providerName : Maybe String
    , providerUrl : Maybe String
    , html : Maybe String
    , witdh : Maybe Int
    , height : Maybe Int
    }


decodeCard : Decoder Card
decodeCard =
    decode Card
        |> required "url" string
        |> required "title" string
        |> required "description" string
        |> required "image" (nullable string)
        |> required "type" decodeCardType
        |> required "author_name" (nullable string)
        |> required "author_url" (nullable string)
        |> required "provider_name" (nullable string)
        |> required "provider_url" (nullable string)
        |> required "html" (nullable string)
        |> required "width" (nullable int)
        |> required "height" (nullable int)


type CardType
    = Link
    | Photo
    | Video
    | Rich


decodeCardType : Decoder CardType
decodeCardType =
    string
        |> Decode.andThen
            (\string ->
                case string of
                    "link" ->
                        Decode.succeed Link

                    "photo" ->
                        Decode.succeed Photo

                    "video" ->
                        Decode.succeed Video

                    "rich" ->
                        Decode.succeed Rich

                    _ ->
                        Decode.fail "Invalid CardType"
            )
