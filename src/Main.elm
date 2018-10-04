module Main exposing (main)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)



-- MODEL --


type alias Model =
    ChuckNorris


type alias ChuckNorris =
    { id : Int
    , chuckNorrisJoke : String
    , categoryList : List String
    }


initModel : ChuckNorris
initModel =
    { id = 0
    , chuckNorrisJoke = "finding new joke"
    , categoryList = []
    }


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "http://api.icndb.com/jokes/random"

        request =
            Http.get url responseDecoder

        cmd =
            Http.send Joke request
    in
    cmd


responseDecoder : Decoder ChuckNorris
responseDecoder =
    decode identity
        |> required "value" chuckNorrisDecoder


chuckNorrisDecoder : Decoder ChuckNorris
chuckNorrisDecoder =
    decode ChuckNorris
        |> required "id" int
        |> required "joke" string
        |> optional "categories" (list string) []


init : ( Model, Cmd Msg )
init =
    ( initModel, randomJoke )



-- UPDATE --


type Msg
    = Joke (Result Http.Error ChuckNorris)
    | GetNewJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke (Ok chuckNorris) ->
            ( { model | chuckNorrisJoke = chuckNorris.chuckNorrisJoke, id = chuckNorris.id, categoryList = chuckNorris.categoryList }, Cmd.none )

        Joke (Err err) ->
            ( { model | chuckNorrisJoke = toString err }, Cmd.none )

        GetNewJoke ->
            ( { model | chuckNorrisJoke = "dj khaled another one" }, randomJoke )



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW --


view : Model -> Html Msg
view model =
    div
        []
        [ span
            []
            [ text ("ID: " ++ toString model.id) ]
        , br [] []
        , span
            []
            [ text ("joke: " ++ model.chuckNorrisJoke) ]
        , br [] []
        , ul [] (List.map categoryListView model.categoryList)
        , br [] []
        , button
            [ onClick GetNewJoke ]
            [ text "get new joke" ]
        ]


categoryListView : String -> Html Msg
categoryListView category =
    li
        []
        [ text "category: "
        , span
            []
            [ text category ]
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
