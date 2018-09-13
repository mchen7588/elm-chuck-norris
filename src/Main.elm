module Main exposing (main)

import Html exposing (..)
import Html.Events exposing (..)
import Http



-- MODEL --


type alias Model =
    String


initModel : Model
initModel =
    "finding new joke"


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "http://api.icndb.com/jokes/random"

        request =
            Http.getString url

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

        Joke (Err error) ->
            ( toString error, Cmd.none )

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
