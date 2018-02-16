module AppRegistration exposing (..)

import Auth.AppRegistration as Registration exposing (RegistrationResponse)
import Auth.Scope as Scope
import Html
import Html.Events as Events
import RemoteData exposing (WebData)


type alias Model =
    { response : WebData RegistrationResponse }


type Msg
    = NoOp
    | RegisterClicked
    | RegistrationResponseReceived (WebData RegistrationResponse)


subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none


info : Registration.RegistrationInfo
info =
    { clientName = "Test of Elm client lib"
    , redirectUris = Nothing
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

        RegisterClicked ->
            ( model
            , Registration.registerApp "mastodon.example.com" info
                |> RemoteData.sendRequest
                |> Cmd.map RegistrationResponseReceived
            )

        RegistrationResponseReceived response ->
            ( { model | response = response }
            , Cmd.none
            )


init : ( Model, Cmd msg )
init =
    ( { response = RemoteData.NotAsked }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.button [ Events.onClick RegisterClicked ]
            [ Html.text "Send app registration" ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
