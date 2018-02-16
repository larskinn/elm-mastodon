module AppRegistration exposing (..)

import Auth.AppRegistration as Registration exposing (RegistrationResponse)
import Auth.Scope as Scope
import Html
import Html.Attributes as Attrs
import Html.Events as Events
import Navigation
import OAuth
import OAuth.AuthorizationCode
import RemoteData exposing (WebData)


type alias Model =
    { location : Navigation.Location
    , registrationInfo : Registration.RegistrationInfo
    , instance : String
    , response : WebData RegistrationResponse
    }


type Msg
    = NoOp
    | LocationChanged Navigation.Location
    | InstanceChanged String
    | RegisterClicked
    | RegistrationResponseReceived (WebData RegistrationResponse)


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
            ( { model | location = location }
            , Cmd.none
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

        RegistrationResponseReceived response ->
            ( { model | response = response }
            , case response of
                RemoteData.Success data ->
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
                    OAuth.AuthorizationCode.authorize req

                _ ->
                    Cmd.none
            )


init : Navigation.Location -> ( Model, Cmd msg )
init location =
    ( { location = location
      , registrationInfo = info location
      , instance = ""
      , response = RemoteData.NotAsked
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


main : Program Never Model Msg
main =
    Navigation.program
        LocationChanged
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
