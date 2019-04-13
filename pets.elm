module Main exposing (main)

import Browser
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Maybe



-- MODEL


type alias Model =
    { redFoxCount : Int
    , goldenRetrieverCount : Int
    , doveCount : Int
    , goldfishCount : Int
    , hedgehogCount : Int
    , luisCount : Int
    , count : Int
    , petCounts : Dict.Dict String Int
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
    , petCounts = Dict.empty
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



-- VIEW


petListElement : Model -> String -> Html PetAppMsg
petListElement model petName =
    let
        petCountMaybe =
            Dict.get petName model.petCounts
    in
    -- if we got a "Just 10" or "Just 3" from `petCountMaybe`, we need to use the inner value, ex 10, or 3
    -- but if we got a "Nothing" we need to use the default (`withDefault`) 0
    let
        petCount =
            Maybe.withDefault 0 petCountMaybe
    in
    li []
        [ button [ onClick Increment ] [ text petName ]
        , span [] [ text (String.fromInt petCount) ]
        ]


view : Model -> Html PetAppMsg
view model =
    div []
        [ h2 [] [ text "Pet Contest" ]
        , div [ class "intro" ] [ text "Vote for your favorite pet" ]
        , span [ class "score-integer" ] [ text (String.fromInt model.count) ]
        , ol [ id "pets", class "pink-text" ]
            [ petListElement model "red fox"
            , petListElement model "golden retriever"
            , petListElement model "dove"
            , petListElement model "hedgehog"
            , petListElement model "luis"
            ]
        ]


main : Program () Model PetAppMsg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
