module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type alias TodoItem =
  { description : String,
    isEditing : Bool
  }

type alias Model =
  List TodoItem

type Msg
    = EditTodoItem TodoItem
    | SaveTodoItem TodoItem
    | UpdateTodoItem TodoItem String
    | DeleteTodoItem TodoItem
    | AddTodoItem


initialModel : Model
initialModel =
  [ TodoItem "Learn elm" False,
    TodoItem "Build elm" False
  ]


updateTodoItem :
  TodoItem ->
  (TodoItem -> TodoItem) ->
  List TodoItem ->
  List TodoItem
updateTodoItem refTodoItem f todoItems=
  List.map
    (\todoItem ->
      if todoItem == refTodoItem then
        f todoItem
      else
        todoItem
    )
    todoItems

editTodoItem : TodoItem -> TodoItem
editTodoItem todoItem =
  { todoItem | isEditing = True }

saveTodoItem : TodoItem -> TodoItem
saveTodoItem todoItem =
  { todoItem | isEditing = False }

setDescription : String -> TodoItem -> TodoItem
setDescription description todoItem =
  { todoItem | description = description }

update : Msg -> Model -> Model
update msg model =
  case msg of
    EditTodoItem refItem ->
      updateTodoItem refItem editTodoItem model

    SaveTodoItem refItem ->
      updateTodoItem refItem saveTodoItem model

    UpdateTodoItem refItem description ->
      updateTodoItem
      refItem
      (setDescription description)
      model

    DeleteTodoItem refItem ->


    AddTodoItem ->
      (TodoItem "Empty" False) :: model

addTodoItemView : String -> Html Msg
addTodoItemView description =
  div [ class "todo-item-add" ]
      [ button
        [ class "btn btn-primary btn-sm",
          onClick AddTodoItem
        ]
        [ text "Add" ]
    ]

editTodoItemView : TodoItem -> Html Msg
editTodoItemView todoItem =
  div [ class "todo-item-edit" ]
      [ input
          [ type_ "text",
            value todoItem.description,
            onInput (UpdateTodoItem todoItem)
          ]
          [],
        button
          [ class "btn btn-primary btn-sm",
            onClick (SaveTodoItem todoItem)
          ]
          [ text "Save" ]
      ]


incompleteTodoItemView : TodoItem -> Html Msg
incompleteTodoItemView todoItem =
  div [ class "todo-item-incomplete" ]
      [ text todoItem.description,
        button
          [ class "btn btn-primary btn-sm",
            onClick (EditTodoItem todoItem)
          ]
          [ text "Edit" ]
      ]

todoItemView : TodoItem -> Html Msg
todoItemView model =
  let
      child =
        if model.isEditing then
          editTodoItemView model
        else
          incompleteTodoItemView model
  in
    li
      [ class "todo-list-item" ]
      [ child ]

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [text "Todo list" ],
      div [] [ addTodoItemView "" ],
      ul [] (List.map todoItemView model)
    ]

main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }
