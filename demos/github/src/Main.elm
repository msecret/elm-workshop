module Main exposing (..)

import Http
import Html exposing (..)
import Html.Attributes exposing (class, disabled, type_, value, src)
import Html.Events exposing (onInput, onClick)
import Json.Decode  exposing (Decoder, string, int)
import Json.Decode.Pipeline exposing (required, decode)


type alias User =
    { id : Int
    , login : String
    , name : String
    , bio : String
    , avatarUrl : String
    }

userDecoder : Decoder User
userDecoder =
  decode User
    |> required "id" int
    |> required "login" string
    |> required "name" string
    |> required "bio" string
    |> required "avatar_url" string

type alias Model =
    { login : String
    , user : Maybe User
    }


type Msg
    = UpdateLogin String
    | FetchUser
    | ReceiveUser (Result Http.Error User)


initialModel : Model
initialModel =
    Model "" Nothing


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

fetchUser : String -> Cmd Msg
fetchUser login =
  let
      url = "http://localhost:3001/users/" ++ login
      request = Http.get url userDecoder
  in
      Http.send ReceiveUser request

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateLogin login ->
            ( { model | login = login }
            , Cmd.none
            )

        FetchUser ->
          ( model, fetchUser model.login )

        ReceiveUser result ->
          case result of
            Ok user ->
              ({ model | user = Just user},
               Cmd.none
              )

            Err _ -> Debug.crash("can't find") (model, Cmd.none)

userView : User -> Html Msg
userView user =
  div [ class "view-user" ]
      [ img
        [ src user.avatarUrl ]
        [],
        div []
          [ h2 [] [text user.name ],
            p [] [text user.bio ]
          ]
      ]


findUserView : Model -> Html Msg
findUserView model =
    div [ class "find-user" ]
        [ h2 [] [ text "Find GitHub User" ]
        , label [] [ text "Login:" ]
        , input
            [ type_ "text"
            , value model.login
            , onInput UpdateLogin
            ]
            []
        , button
            [ class "btn btn-primary"
            , disabled (model.login == "")
            , onClick FetchUser
            ]
            [ text "Find" ]
        ]

view : Model -> Html Msg
view model =
  case model.user of
    Just user ->
      userView user
    Nothing ->
      findUserView model


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
