module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
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
    | Success State


type alias State =
    { input : String
    , todos : List Todo
    }


type alias Todo =
    { id : Int
    , title : String
    , completed : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getTodos )



-- UPDATE


type Msg
    = DeleteTodo Int
    | CreateTodo String
    | GotTodos (Result Http.Error (List Todo))
    | ChangeInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DeleteTodo deleteId ->
            case model of
                Success state ->
                    -- filter todos to remove the one with the given id
                    ( Success
                        { state
                            | todos =
                                List.filter
                                    (\item -> item.id /= deleteId)
                                    state.todos
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        CreateTodo title ->
            case model of
                Success state ->
                    -- add the new todo to the beginning of the list
                    ( Success
                        { input = ""
                        , todos =
                            { id = List.length state.todos + 1
                            , title = title
                            , completed = False
                            }
                                :: state.todos
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        GotTodos result ->
            case result of
                Ok todos ->
                    case model of
                        Loading ->
                            ( Success { input = "", todos = todos }, Cmd.none )

                        _ ->
                            ( model, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )

        ChangeInput value ->
            case model of
                Success state ->
                    ( Success { state | input = value }, Cmd.none )

                _ ->
                    ( model, Cmd.none )



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

        Success state ->
            main_ []
                [ viewTodoForm state.input
                , viewTodoList state.todos
                ]


viewTodoForm : String -> Html Msg
viewTodoForm inputValue =
    form [ onSubmit (CreateTodo inputValue) ]
        [ input
            [ type_ "text"
            , value inputValue
            , placeholder "Create a new todo..."
            , attribute "aria-label" "create a new todo"
            , onInput ChangeInput
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
