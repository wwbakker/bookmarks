module Main exposing (Model, Msg(..), init, main, update, view)

import Array
import Bookmarks exposing (Bookmark, BookmarkGroup)
import Browser
import Browser.Navigation exposing (load)
import Dom exposing (SelectionIndex, bookmarkGroupsToHtml, css)
import Filtering exposing (filterBookmarkGroups)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onInput)
import Json.Decode
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import PublicBookmarks exposing (bookmarkGroups)


main =
    Browser.element { init = \() -> init, view = view, update = update, subscriptions = \_ -> Sub.none }


type alias Model =
    { filteredBookmarkGroups : List BookmarkGroup, selectedBookmarkGroupIndex : SelectionIndex, selectedBookmarkIndex : SelectionIndex }


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


updateSelection : Model -> KeyboardEvent -> Model
updateSelection model kbEvent =
    { model
        | selectedBookmarkGroupIndex =
            case kbEvent.key of
                Just key ->
                    if key == "ArrowDown" then
                        modBy (List.length model.filteredBookmarkGroups) (model.selectedBookmarkGroupIndex + 1)

                    else if key == "ArrowUp" then
                        if (model.selectedBookmarkGroupIndex - 1) < 0 then
                            List.length model.filteredBookmarkGroups - 1

                        else
                            model.selectedBookmarkGroupIndex - 1

                    else
                        0

                Nothing ->
                    model.selectedBookmarkGroupIndex
    }


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


selectedBookmark : Model -> Maybe Bookmark
selectedBookmark model =
    case getByIndex model.selectedBookmarkGroupIndex model.filteredBookmarkGroups of
        Nothing ->
            Nothing

        Just bmg ->
            getByIndex model.selectedBookmarkIndex bmg.bookmarks


getByIndex : Int -> List a -> Maybe a
getByIndex index list =
    Array.get index (Array.fromList list)


view : Model -> Html Msg
view model =
    div
        []
        [ Html.node "style" [] [ text css ]
        , div [] (bookmarkGroupsToHtml model.filteredBookmarkGroups model.selectedBookmarkGroupIndex model.selectedBookmarkIndex)
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
