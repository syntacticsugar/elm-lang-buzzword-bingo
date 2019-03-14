-- note, hard reload browser to view changes.  sometimes your code ISN'T wrong, it's the browser


module Bingo exposing (Entry, Model, Msg(..), initialEntries, initialModel, main, playerInfo, update, view, viewEntryItem, viewEntryList, viewFooter, viewHeader, viewPlayer)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Random



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
    , Entry 3 "Strategic Partner" 200 False
    , Entry 4 "Blockchain Startup" 400 False
    ]



--UPDATE
-- the following is called a `union type`


type Msg
    = NewGame
    | Mark Int
    | NewRandom Int
    | NewEntries (Result Http.Error String)



-- update function is stateless.  you return a new model.
-- remember, all these need to return a tuple, last of which is a COMMAND
-- we don't need a command for NewRandom.  I forgot why tho


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- remember, all these need to return a tuple, last of which is a COMMAND
        NewRandom randomNumber ->
            -- we don't need a command for NewRandom.  I forgot why tho
            ( { model | gameNumber = randomNumber }, Cmd.none )

        NewGame ->
            ( { model | gameNumber = model.gameNumber + 1 }, commandGetEntries )

        NewEntries (Ok jsonString) ->
            let
                _ =
                    Debug.log "congration, you dun it" jsonString
            in
            ( model, Cmd.none )

        NewEntries (Err error) ->
            let
                _ =
                    Debug.log "Oops, you dun goofed." error
            in
            ( model, Cmd.none )

        Mark id ->
            let
                markEntry e =
                    if e.id == id then
                        { e | marked = not e.marked }

                    else
                        e
            in
            ( { model | entries = List.map markEntry model.entries }, Cmd.none )



--COMMANDS


commandGenerateRandomNo : Cmd Msg
commandGenerateRandomNo =
    --every command needs to produce a message for our update function when the command is finished
    --hence first arg to Random.generate is a function to create the message holding the random
    Random.generate (\num -> NewRandom num) (Random.int 1 100)


entriesUrl : String
entriesUrl =
    "http://localhost:3000/random-entries"


commandGetEntries : Cmd Msg
commandGetEntries =
    -- send : (Result Http.Error String -> Msg) -> Request String -> Cmd Msg
    entriesUrl
        |> Http.getString
        |> Http.send NewEntries



--once NewRandom is added to our custom type, we get a free constructor function = syntactic sugar:
-- Random.generate NewRandom (Random.int 1 100)
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


sumMarkedPoints : List Entry -> Int
sumMarkedPoints entries =
    --    let
    --       markedEntries =
    --          -- List.filter .marked entries
    --         List.filter (\e -> e.marked) entries
    --
    --       pointValues =
    --          List.map .point markedEntries
    -- in
    --List.sum pointValues
    -- alternatively, more flashy syntax :
    --  entries
    --|> List.filter .marked
    --|> List.foldl (\e sum -> sum + e.points) 0
    entries
        |> List.filter .marked
        |> List.map .points
        |> List.sum


viewScore : Int -> Html Msg
viewScore sum =
    div
        [ class "score" ]
        [ span [ class "label" ] [ text "Score" ]
        , span [ class "value" ] [ text (toString sum) ]
        ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ viewHeader "TECH BRO Buzzword Bingo"
        , viewPlayer model.name model.gameNumber
        , viewEntryList model.entries
        , viewScore (sumMarkedPoints model.entries)
        , div [ class "button-group" ]
            [ button [ onClick NewGame ] [ text "Start Anew" ] ]
        , div [ class "debug" ] [ text (toString model) ]
        , viewFooter
        ]


init : ( Model, Cmd Msg )
init =
    ( initialModel, commandGetEntries )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update

        --, subscriptions = \model -> Sub.none
        -- always : a -> b -> a
        -- It takes an a value and a b value, but always returns the a value. Thus, it's a constant function. In the subscription example, we're calling always in a curried form by passing just the first argument (the a value):
        -- The second argument (the b value) is the model argument which we ignored using _ in our anonymous function. So we can achieve the same thing using always because it always completely ignores the second argument!
        , subscriptions = always Sub.none
        }
