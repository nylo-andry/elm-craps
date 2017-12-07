module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import Random exposing (pair, generate)


-- MODEL


type alias Model =
    { roll : DiceFaces
    , phase : GamePhase
    , total : Int
    , result : GameResult
    }


type alias DiceFaces =
    ( Int, Int )


type GamePhase
    = ComeOut
    | Point Int


type GameResult
    = None
    | Win
    | Lose


initialRoll : DiceFaces
initialRoll =
    ( 1, 1 )


initialModel : Model
initialModel =
    { roll = initialRoll
    , total = calculateTotal initialRoll
    , phase = ComeOut
    , result = None
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- UPDATE


type Msg
    = RollDice
    | NewFaces DiceFaces


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RollDice ->
            ( model, generateNewDiceFaces )

        NewFaces diceFaces ->
            ( updateModel model diceFaces
            , Cmd.none
            )


updateModel : Model -> DiceFaces -> Model
updateModel model diceFaces =
    let
        total = calculateTotal diceFaces
        phase = computePhase model.phase total
    in
        { model | total = total, phase = phase, roll = diceFaces }
        

computePhase : GamePhase -> Int -> GamePhase
computePhase phase total =
    case phase of
        ComeOut ->
            if (total == 7) || (total == 11)
            then ComeOut
            else Point total
        Point point ->
            if total == point
            then ComeOut
            else Point point


calculateTotal : DiceFaces -> Int
calculateTotal diceFaces =
    let
        firstDiceFace =
            Tuple.first diceFaces

        secondDiceFace =
            Tuple.second diceFaces
    in
        firstDiceFace + secondDiceFace


generateNewDiceFaces : Cmd Msg
generateNewDiceFaces =
    generate NewFaces (pair (Random.int 1 6) (Random.int 1 6))



-- VIEW


view : Model -> Html Msg
view model =
    let
        dice1 =
            Tuple.first model.roll

        dice2 =
            Tuple.second model.roll
    in
        div [ class "app" ]
            [ viewPhase model.phase
            , viewDice dice1
            , viewDice dice2
            , span [] [ text ("Last Roll: " ++ (toString model.total)) ]
            , button [ onClick RollDice ] [ text "Roll!" ]
            ]


viewDice : Int -> Html Msg
viewDice face =
    let
        faceFile =
            toString face ++ ".png"

        diceUrl =
            "assets/images/" ++ faceFile
    in
        img [ class "dice-image", src diceUrl ] []


viewPhase : GamePhase -> Html Msg
viewPhase phase =
    let
        phaseText = case phase of
            ComeOut ->
                "Come out Roll"
            Point point ->
                "Point: " ++ toString point
    in
        h2 [] [ text phaseText ]

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
