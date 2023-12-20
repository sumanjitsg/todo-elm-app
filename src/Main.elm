module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


todos =
    [ { id = 1, title = "Pick up groceries", completed = True }
    , { id = 2, title = "Jog around the park 3x", completed = False }
    , { id = 3, title = "10 minutes meditation", completed = False }
    , { id = 4, title = "Read for 30 minutes", completed = False }
    , { id = 5, title = "Complete this todo app", completed = False }
    ]


todoView todo =
    li []
        [ text todo.title
        , button [ class "button--delete-todo" ] [ text "X" ]
        ]


todoListView =
    ul [] (List.map todoView todos)


main =
    main_ [] [ todoListView ]
