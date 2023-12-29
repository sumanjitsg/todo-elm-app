module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, type_)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, view = view, update = update }



-- MODEL


type alias Model =
    { todos : List Todo }


type alias Todo =
    { id : Int, title : String, completed : Bool }


init : Model
init =
    Model
        -- List of todos
        [ { id = 1, title = "Pick up groceries", completed = True }
        , { id = 2, title = "Jog around the park 3x", completed = False }
        , { id = 3, title = "10 minutes meditation", completed = False }
        , { id = 4, title = "Read for 30 minutes", completed = False }
        , { id = 5, title = "Complete this todo app", completed = False }
        ]



-- UPDATE


type Msg
    = DeleteTodo Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        DeleteTodo deleteId ->
            { model
                | todos =
                    List.filter (\item -> item.id /= deleteId) model.todos
            }



-- VIEW


view : Model -> Html Msg
view model =
    main_ []
        [ viewTodoForm
        , viewTodoList model.todos
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
