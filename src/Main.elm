module Main exposing (main)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)



-- MODEL --


type alias Model =
    String


initModel : String
initModel =
    "finding new joke"


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "http://api.icndb.com/jokes/random"

        request =
            Http.get url (at [ "value", "joke" ] string)

        cmd =
            Http.send Joke request
    in
    cmd


init : ( Model, Cmd Msg )
init =
    ( initModel, randomJoke )



-- UPDATE --


type Msg
    = Joke (Result Http.Error String)
    | GetNewJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke (Ok joke) ->
            ( joke, Cmd.none )

        Joke (Err err) ->
            ( toString err, Cmd.none )

        GetNewJoke ->
            ( "findind another joke", randomJoke )



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW --


view : Model -> Html Msg
view model =
    div
        []
        [ text model
        , br [] []
        , button
            [ onClick GetNewJoke ]
            [ text "get new joke" ]
        ]



-- MAIN --


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
