module Main exposing (Msg(..), init, main, update, view)

import Browser
import Browser.Navigation exposing (load)
import DataModel exposing (Bookmark, BookmarkGroup, Model)
import Dom exposing (bookmarkGroupsToHtml)
import Filtering exposing (filterBookmarkGroups)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (on, onInput)
import Json.Decode
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import PublicBookmarks exposing (bookmarkGroups)
import Selecting exposing (selectedBookmark, updateSelection)


main : Program () Model Msg
main =
    Browser.element { init = \() -> init, view = view >> toUnstyled, update = update, subscriptions = \_ -> Sub.none }


init : ( Model, Cmd message )
init =
    ( { filteredBookmarkGroups = bookmarkGroups
      , selectedBookmarkGroupIndex = 0
      , selectedBookmarkIndex = 0
      }
    , Cmd.none
    )


type Msg
    = Filter String
    | HandleKeyboardEvent KeyboardEvent


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Filter newFilterString ->
            ( { model
                | filteredBookmarkGroups = filterBookmarkGroups newFilterString bookmarkGroups
              }
            , Cmd.none
            )

        HandleKeyboardEvent event ->
            ( updateSelection model event
            , redirectToBookmark model event
            )


redirectToBookmark : Model -> KeyboardEvent -> Cmd Msg
redirectToBookmark model kbEvent =
    case kbEvent.key of
        Just key ->
            if key == "Enter" then
                case selectedBookmark model of
                    Just bm ->
                        load bm.href

                    Nothing ->
                        Cmd.none

            else
                Cmd.none

        Nothing ->
            Cmd.none


view : Model -> Html Msg
view model =
    div
        []
        [ bookmarkGroupsToHtml model.filteredBookmarkGroups model.selectedBookmarkGroupIndex model.selectedBookmarkIndex
        , input
            [ placeholder "filter"
            , onInput Filter
            , on "keydown" <|
                Json.Decode.map HandleKeyboardEvent decodeKeyboardEvent
            , tabindex 0
            , id "outermost"
            , autofocus True
            ]
            []
        ]
