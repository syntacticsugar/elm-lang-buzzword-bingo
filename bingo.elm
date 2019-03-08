module Bingo exposing (Entry, Model, Msg(..), initialEntries, initialModel, main, playerInfo, update, view, viewEntryItem, viewEntryList, viewFooter, viewHeader, viewPlayer)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { name : String
    , gameNumber : Int
    , entries : List Entry
    }


type alias Entry =
    { id : Int
    , phrase : String
    , points : Int
    , marked : Bool
    }


initialModel : Model
initialModel =
    { name = "Alice"
    , gameNumber = 1
    , entries = initialEntries
    }


initialEntries : List Entry
initialEntries =
    [ Entry 1 "Future-Proof" 100 False
    , Entry 2 "Parallel Processing" 200 False
    , Entry 3 "React Redux JS" 200 False
    , Entry 4 "Blockchain Startup" 400 False
    ]



--UPDATE
-- the following is called a `union type`


type Msg
    = NewGame
    | Mark Int



-- update function is stateless.  you return a new model.


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewGame ->
            { model
                | gameNumber = model.gameNumber + 1
                , entries = initialEntries
            }

        Mark id ->
            let
                markEntry e =
                    if e.id == id then
                        { e | marked = not e.marked }

                    else
                        e
            in
            { model | entries = List.map markEntry model.entries }



--VIEW


playerInfo : String -> Int -> String
playerInfo name gameNumber =
    name ++ "  - Game #" ++ toString gameNumber


viewPlayer : String -> Int -> Html Msg
viewPlayer name gameNumber =
    let
        playerInfoText =
            playerInfo name gameNumber
                |> String.toUpper
                |> text
    in
    h2 [ id "info", class "classy" ]
        [ playerInfoText ]


viewHeader : String -> Html Msg
viewHeader title =
    header []
        [ h1 [] [ text title ] ]


viewFooter : Html Msg
viewFooter =
    footer []
        [ a [ href "http://elm-lang.org" ]
            [ text "Fueled by Elm." ]
        ]


viewEntryItem : Entry -> Html Msg
viewEntryItem entry =
    li [ classList [ ( "marked", entry.marked ) ], onClick (Mark entry.id) ]
        [ span [ class "phrase" ] [ text entry.phrase ]
        , span [ class "points" ] [ text (toString entry.points) ]
        ]


viewEntryList : List Entry -> Html Msg
viewEntryList entries =
    entries
        |> List.map viewEntryItem
        --List.map returns a list for us, no need for [] syntax
        |> ul []


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ viewHeader "Buzzword Bingo"
        , viewPlayer model.name model.gameNumber
        , viewEntryList model.entries
        , div [ class "button-group" ]
            [ button [ onClick NewGame ] [ text "Start Anew" ] ]
        , div [ class "debug" ] [ text (toString model) ]
        , viewFooter
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }
