module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { redFoxCount : Int
    , goldenRetrieverCount : Int
    , doveCount : Int
    , goldfishCount : Int
    , hedgehogCount : Int
    , luisCount : Int
    , count : Int
    }


initialModel : Model
initialModel =
    { redFoxCount = 0
    , goldenRetrieverCount = 0
    , doveCount = 0
    , goldfishCount = 0
    , hedgehogCount = 0
    , luisCount = 0
    , count = 0
    }


type PetAppMsg
    = Increment
    | Decrement



-- UPDATE


update : PetAppMsg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }



-- UPDATE


view : Model -> Html PetAppMsg
view model =
    div []
        [ h2 [] [ text "Pet Contest" ]
        , div [ class "intro" ] [ text "Vote for your favorite pet" ]

        --, div [class "score"] [ text "Score: " ]
        --, span [ class "score" ] [ text "SCORE: " ]
        , span [ class "score-integer" ] [ text (String.fromInt model.count) ]
        , ol [ id "pets", class "pink-text" ]
            [ li []
                [ button [ onClick Increment ] [ text "red fox" ]
                , span [] [ text (String.fromInt model.redFoxCount) ]
                ]
            , li [] [ button [ onClick Increment ] [ text "golden retriever" ] ]
            , li [] [ button [ onClick Increment ] [ text "dove" ] ]
            , li [] [ button [ onClick Increment ] [ text "goldfish" ] ]
            , li [] [ button [ onClick Increment ] [ text "hedgehog" ] ]
            , li [] [ button [ onClick Increment ] [ text "luis" ] ]
            ]
        ]


main : Program () Model PetAppMsg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
