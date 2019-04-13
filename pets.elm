module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { count : Int }


initialModel : Model
initialModel =
    { count = 0 }


type Msg
    = Increment
    | Decrement



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }



-- UPDATE


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Pet Contest" ]
        , div [ class "intro" ] [ text "Vote for your favorite pet" ]

        --, div [class "score"] [ text "Score: " ]
        , div [ class "score" ] [ text "SCORE: ", text (String.fromInt model.count) ]
        , ol [ id "pets", class "pink-text" ]
            [ li [] [ button [ onClick Increment ] [ text "red fox" ] ]
            , li [] [ button [ onClick Increment ] [ text "golden retriever" ] ]
            , li [] [ button [ onClick Increment ] [ text "dove" ] ]
            , li [] [ button [ onClick Increment ] [ text "goldfish" ] ]
            , li [] [ button [ onClick Increment ] [ text "hedgehog" ] ]
            , li [] [ button [ onClick Increment ] [ text "luis" ] ]
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
