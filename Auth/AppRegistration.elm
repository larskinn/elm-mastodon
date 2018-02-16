module Auth.AppRegistration
    exposing
        ( RegistrationInfo
        , RegistrationResponse
        , registerApp
        )

import Auth.Scope as Scope exposing (Scope)
import Http exposing (Body, Part, multipartBody, stringPart)
import Internal.Decoding exposing (decodeId)
import Json.Decode exposing (Decoder, nullable, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias RegistrationInfo =
    { clientName : String
    , redirectUris : Maybe String
    , scopes : List Scope
    , website : Maybe String
    }


toBody : RegistrationInfo -> Body
toBody info =
    let
        redirectUris =
            Maybe.withDefault "urn:ietf:wg:oauth:2.0:oob" info.redirectUris

        scopes =
            List.map Scope.toString info.scopes |> String.join " "
    in
    multipartBody
        [ stringPart "client_name" info.clientName
        , stringPart "redirect_uris" redirectUris
        , stringPart "scopes" scopes
        , stringPart "website" (Maybe.withDefault "" info.website)
        ]


type alias RegistrationResponse =
    { appId : String
    , name : String
    , website : Maybe String
    , redirectUri : String
    , clientId : String
    , clientSecret : String
    }


decodeResponse : Decoder RegistrationResponse
decodeResponse =
    decode RegistrationResponse
        |> required "id" decodeId
        |> required "name" string
        |> required "website" (nullable string)
        |> required "redirect_uri" string
        |> required "client_id" string
        |> required "client_secret" string


registerApp : String -> RegistrationInfo -> Http.Request RegistrationResponse
registerApp instanceHostname registrationInfo =
    let
        url =
            "https://" ++ instanceHostname ++ "/api/v1/apps"

        body =
            toBody registrationInfo
    in
    Http.post url body decodeResponse
