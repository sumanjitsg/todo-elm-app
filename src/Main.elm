module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, type_)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder)



-- MAIN


main : Program () Model Msg
main =
    Browser.element { init = init, view = view, subscriptions = subscriptions, update = update }



-- MODEL


type Model
    = Failure
    | Loading
    | Success (List Todo)


type alias Todo =
    { id : Int, title : String, completed : Bool }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getTodos )



-- UPDATE


type Msg
    = DeleteTodo Int
    | GotTodos (Result Http.Error (List Todo))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DeleteTodo deleteId ->
            case model of
                Success todos ->
                    ( Success (List.filter (\item -> item.id /= deleteId) todos), Cmd.none )

                _ ->
                    -- TODO: Add failure and loading cases
                    ( model, Cmd.none )

        GotTodos result ->
            case result of
                Ok todos ->
                    ( Success todos, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            div [] [ text "Error loading todos" ]

        Loading ->
            div [] [ text "Loading todos..." ]

        Success todos ->
            main_ []
                [ viewTodoForm
                , viewTodoList todos
                ]


viewTodoForm : Html Msg
viewTodoForm =
    form []
        [ input
            [ type_ "text"
            , placeholder "Create a new todo..."
            , attribute "aria-label" "create a new todo"
            ]
            []
        ]


viewTodoList : List Todo -> Html Msg
viewTodoList items =
    ul []
        (List.map viewTodoItem items)


viewTodoItem : Todo -> Html Msg
viewTodoItem item =
    li []
        [ text item.title
        , button
            [ class "button--delete-todo"
            , onClick (DeleteTodo item.id)
            ]
            [ text "X" ]
        ]



-- HTTP


getTodos : Cmd Msg
getTodos =
    Http.get
        { url = "https://jsonplaceholder.typicode.com/todos"
        , expect = Http.expectJson GotTodos todosDecoder
        }


todosDecoder : Decoder (List Todo)
todosDecoder =
    Decode.list todoDecoder


todoDecoder : Decoder Todo
todoDecoder =
    Decode.map3 Todo
        (Decode.field "id" Decode.int)
        (Decode.field "title" Decode.string)
        (Decode.field "completed" Decode.bool)
