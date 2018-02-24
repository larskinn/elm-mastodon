port module Main exposing (..)

import Auth.AppRegistration as Registration exposing (RegistrationResponse)
import Auth.Scope as Scope
import Html
import Html.Attributes as Attrs
import Html.Events as Events
import Json.Decode as Decode exposing (Decoder, field, int, list, nullable, string)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Json.Encode as Encode exposing (Value, encode)
import Json.Encode.Extra as Encode
import Maybe.Extra as Maybe
import Navigation
import OAuth
import OAuth.AuthorizationCode
import RemoteData exposing (WebData)


port saveToLocalStorage : Value -> Cmd msg


type alias Flags =
    Value


decodeStoredModel : Decoder StoredModel
decodeStoredModel =
    decode StoredModel
        |> optional "credentials" (nullable decodeCredentials) Nothing
        |> optional "token" (nullable decodeResponseToken) Nothing


encodeStoredModel : StoredModel -> Value
encodeStoredModel model =
    Encode.object
        [ ( "credentials", Encode.maybe encodeCredentials model.credentials )
        , ( "token", Encode.maybe encodeResponseToken model.token )
        ]


decodeCredentials : Decoder OAuth.Credentials
decodeCredentials =
    decode OAuth.Credentials
        |> required "clientId" string
        |> required "secret" string


encodeCredentials : OAuth.Credentials -> Value
encodeCredentials credentials =
    Encode.object
        [ ( "clientId", Encode.string credentials.clientId )
        , ( "secret", Encode.string credentials.secret )
        ]


decodeResponseToken : Decoder OAuth.ResponseToken
decodeResponseToken =
    decode OAuth.ResponseToken
        |> required "expiresIn" (nullable int)
        |> required "refreshToken" (nullable decodeToken)
        |> required "scope" (list string)
        |> required "state" (nullable string)
        |> required "token" decodeToken


encodeResponseToken : OAuth.ResponseToken -> Value
encodeResponseToken responseToken =
    Encode.object
        [ ( "expiresIn", Encode.maybe Encode.int responseToken.expiresIn )
        , ( "refreshToken", Encode.maybe encodeToken responseToken.refreshToken )
        , ( "scope", Encode.list (List.map Encode.string responseToken.scope) )
        , ( "state", Encode.maybe Encode.string responseToken.state )
        , ( "token", encodeToken responseToken.token )
        ]


decodeToken : Decoder OAuth.Token
decodeToken =
    string |> Decode.map OAuth.Bearer


encodeToken : OAuth.Token -> Value
encodeToken token =
    case token of
        OAuth.Bearer string ->
            Encode.string string


type alias StoredModel =
    { credentials : Maybe OAuth.Credentials
    , token : Maybe OAuth.ResponseToken
    }


type alias Model =
    { location : Navigation.Location
    , registrationInfo : Registration.RegistrationInfo
    , instance : String
    , credentials : Maybe OAuth.Credentials
    , token : Maybe OAuth.ResponseToken
    }


type Msg
    = NoOp
    | LocationChanged Navigation.Location
    | InstanceChanged String
    | RegisterClicked
    | RegistrationResponseReceived (WebData RegistrationResponse)
    | AuthenticationResponseReceived (WebData OAuth.ResponseToken)


subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none


info : Navigation.Location -> Registration.RegistrationInfo
info location =
    { clientName = "Test of Elm client lib"
    , redirectUris = Just location.href
    , scopes = [ Scope.Read, Scope.Follow ]
    , website = Nothing
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        LocationChanged location ->
            let
                auth : Maybe OAuth.ResponseCode
                auth =
                    OAuth.AuthorizationCode.parse location |> Result.toMaybe
            in
            ( { model | location = location }
            , case ( auth, model.credentials ) of
                ( Nothing, _ ) ->
                    Cmd.none

                ( _, Nothing ) ->
                    Cmd.none

                ( Just authorization, Just credentials ) ->
                    let
                        authentication =
                            OAuth.AuthorizationCode
                                { credentials = credentials
                                , code = authorization.code
                                , redirectUri = model.registrationInfo.redirectUris |> Maybe.withDefault ""
                                , scope = List.map Scope.toString model.registrationInfo.scopes
                                , state = authorization.state
                                , url = "https://" ++ model.instance ++ "/oauth/token"
                                }
                    in
                    OAuth.AuthorizationCode.authenticate authentication
                        |> RemoteData.sendRequest
                        |> Cmd.map AuthenticationResponseReceived
            )

        InstanceChanged instance ->
            ( { model | instance = instance }
            , Cmd.none
            )

        RegisterClicked ->
            ( model
            , Registration.registerApp model.instance model.registrationInfo
                |> RemoteData.sendRequest
                |> Cmd.map RegistrationResponseReceived
            )

        RegistrationResponseReceived (RemoteData.Success data) ->
            let
                req : OAuth.Authorization
                req =
                    { clientId = data.clientId
                    , url = "https://" ++ model.instance ++ "/oauth/authorize"
                    , redirectUri = data.redirectUri
                    , responseType = OAuth.Code
                    , scope = List.map Scope.toString model.registrationInfo.scopes
                    , state = Nothing
                    }
            in
            ( { model
                | credentials =
                    Just
                        { clientId = data.clientId
                        , secret = data.clientSecret
                        }
              }
            , Cmd.batch
                [ saveToLocalStorage <|
                    encodeStoredModel
                        { credentials = model.credentials
                        , token = model.token
                        }
                , OAuth.AuthorizationCode.authorize req
                ]
            )

        RegistrationResponseReceived _ ->
            ( model, Cmd.none )

        AuthenticationResponseReceived (RemoteData.Success token) ->
            ( { model | token = Just token }
            , Cmd.none
            )

        AuthenticationResponseReceived _ ->
            ( model, Cmd.none )


init : Flags -> Navigation.Location -> ( Model, Cmd msg )
init flags location =
    let
        storedModel : Maybe StoredModel
        storedModel =
            Decode.decodeValue decodeStoredModel flags |> Result.toMaybe
    in
    ( { location = location
      , registrationInfo = info location
      , instance = ""
      , credentials = Maybe.map .credentials storedModel |> Maybe.join
      , token = Maybe.map .token storedModel |> Maybe.join
      }
    , Cmd.none
    )


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.div []
            [ Html.label []
                [ Html.text "Mastodon instance"
                , Html.input
                    [ Attrs.value model.instance
                    , Attrs.placeholder "E.g. mastodon.example.com"
                    , Events.onInput InstanceChanged
                    ]
                    []
                ]
            ]
        , Html.button [ Events.onClick RegisterClicked ]
            [ Html.text "Send app registration" ]
        ]


main : Program Flags Model Msg
main =
    Navigation.programWithFlags
        LocationChanged
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
