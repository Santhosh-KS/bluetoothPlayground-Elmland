module Pages.Home_ exposing (Model, Msg, page)

-- import Components.Hero exposing (Hero)
-- import Json.Encode

import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    { btDetails : Maybe Shared.BtDeviceDetails
    , testString : String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { btDetails = Nothing
      , testString = "Default TestStrin"
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = UserClickedButton
    | ReceivedMsgFromJS Json.Decode.Value
    | ReceivingStringsFromJS String


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        UserClickedButton ->
            ( model
            , Effect.openWindowDialog "Hello, from Elm!"
            )

        ReceivedMsgFromJS rxJson ->
            let
                _ =
                    Debug.log "Receving Update for JSON: " rxJson
            in
            case Json.Decode.decodeValue Shared.btDetailsDecoder rxJson of
                Ok data ->
                    let
                        _ =
                            Debug.log "Receving Update for JSON OBJ MYDetails: " data
                    in
                    ( { model | btDetails = Just data }
                    , Effect.none
                    )

                Err _ ->
                    let
                        _ =
                            Debug.log "ERRO Passiert OBJ : " model
                    in
                    ( model, Effect.none )

        ReceivingStringsFromJS str ->
            let
                _ =
                    Debug.log "Receving Update for STRING : " str
            in
            ( { model | testString = str }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Effect.incoming ReceivedMsgFromJS
        , Effect.receivingString ReceivingStringsFromJS
        ]


testView : String -> Html Msg
testView m =
    Html.div [ Attr.class "container pt-4" ]
        [ Html.p [] [ Html.text "ReceivedString: ", Html.text m ]
        ]


btDataView : Shared.BtDeviceDetails -> Html Msg
btDataView data =
    let
        status =
            if data.status then
                "YES"

            else
                "NO"
    in
    Html.div [ Attr.class "container pt-4" ]
        [ Html.p [] [ Html.text "ID: ", Html.text data.id ]
        , Html.p [] [ Html.text "Name: ", Html.text data.name ]
        , Html.p [] [ Html.text "Connected: ", Html.text status ]
        ]


btButton : Html Msg
btButton =
    Html.div [ Attr.class "container" ]
        [ Html.div [ Attr.class "columns py-3" ]
            []
        , Html.div [ Attr.class "column" ]
            [ Html.button
                [ Attr.class "button is-link"
                , Events.onClick
                    UserClickedButton
                ]
                [ Html.text "Bluetooth Devices near me" ]
            ]
        ]


view : Model -> View Msg
view model =
    let
        btd =
            case model.btDetails of
                Just details ->
                    details

                Nothing ->
                    { name = "Default"
                    , id = "NOTHING"
                    , status = False
                    }
    in
    { title = "Home"
    , body =
        [ btButton
        , testView model.testString
        , btDataView btd
        ]
    }
