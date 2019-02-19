module Bingo exposing (main, playerInfo, view, viewFooter, viewHeader, viewPlayer)

import Html exposing (..)
import Html.Attributes exposing (..)



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
    , Entry 1 "Agile Development" 200 False
    , Entry 1 "React JS" 400 False
    , Entry 1 "Blockchain Startup" 200 False
    ]



--VIEW


playerInfo : String -> Int -> String
playerInfo name gameNumber =
    name ++ "  - Game #" ++ toString gameNumber


viewPlayer : String -> Int -> Html msg
viewPlayer name gameNumber =
    let
        playerInfoText =
            playerInfo name gameNumber
                |> String.toUpper
                |> text
    in
    h2 [ id "info", class "classy" ]
        [ playerInfoText ]


viewHeader : String -> Html msg
viewHeader title =
    header []
        [ h1 [] [ text title ] ]


viewFooter : Html msg
viewFooter =
    footer []
        [ a [ href "http://elm-lang.org" ]
            [ text "Fueled by Elm." ]
        ]


viewEntryItem : Entry -> Html msg
viewEntryItem entry =
    li []
        [ span [ class "phrase" ] [ text entry.phrase ]
        , span [ class "points" ] [ text (toString entry.points) ]
        ]


viewEntryList : List Entry -> Html msg
viewEntryList entries =
    let
        listOfEntries =
            List.map viewEntryItem entries
    in
    ul [] listOfEntries


view : Model -> Html msg
view model =
    div [ class "content" ]
        [ viewHeader "Buzzword Bingo"
        , viewPlayer model.name model.gameNumber
        , viewEntryList model.entries
        , div [ class "debug" ] [ text (toString model) ]
        , viewFooter
        ]


main : Html msg
main =
    view initialModel
