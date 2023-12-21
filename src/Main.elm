module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, type_)



-- MODEL


initialModel =
    { todos =
        [ { id = 1, title = "Pick up groceries", completed = True }
        , { id = 2, title = "Jog around the park 3x", completed = False }
        , { id = 3, title = "10 minutes meditation", completed = False }
        , { id = 4, title = "Read for 30 minutes", completed = False }
        , { id = 5, title = "Complete this todo app", completed = False }
        ]
    }



-- UPDATE


update msg model =
    model



-- VIEW


todoItemView item =
    li []
        [ text item.title
        , button [ class "button--delete-todo" ] [ text "X" ]
        ]


todoListView items =
    ul [] (List.map todoItemView items)


todoFormView =
    form []
        [ input [ type_ "text", placeholder "Create a new todo...", attribute "aria-label" "create a new todo" ] [] ]


view model =
    main_ [] [ todoFormView, todoListView model.todos ]


main =
    Browser.sandbox { init = initialModel, view = view, update = update }
