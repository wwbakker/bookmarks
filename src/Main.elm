module Main exposing (Model, Msg(..), init, main, update, view)

import Array
import Bookmarks exposing (Bookmark, BookmarkGroup)
import Browser
import Browser.Navigation exposing (load)
import Dom exposing (SelectionIndex, bookmarkGroupsToHtml)
import Filtering exposing (filterBookmarkGroups)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (on, onInput)
import Json.Decode
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import PublicBookmarks exposing (bookmarkGroups)
import Regex


main : Program () Model Msg
main =
    Browser.element { init = \() -> init, view = view >> toUnstyled, update = update, subscriptions = \_ -> Sub.none }


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


type SelectAction
    = Down
    | Up
    | NoAction
    | Reset


updatedIndex : SelectionIndex -> Int -> SelectAction -> SelectionIndex
updatedIndex currentSelectionIndex listLength selectAction =
    case selectAction of
        Down ->
            modBy listLength (currentSelectionIndex + 1)

        Up ->
            if (currentSelectionIndex - 1) < 0 then
                listLength - 1

            else
                currentSelectionIndex - 1

        NoAction ->
            currentSelectionIndex

        Reset ->
            0


letterRegex : Regex.Regex
letterRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "^\\w$"


selectionActionFromKeyboardEvent : KeyboardEvent -> String -> String -> SelectAction
selectionActionFromKeyboardEvent kbEvent upKey downKey =
    case kbEvent.key of
        Just key ->
            if key == downKey then
                Down

            else if key == upKey then
                Up

            else if Regex.contains letterRegex key then
                Reset

            else
                NoAction

        Nothing ->
            NoAction


updateSelection : Model -> KeyboardEvent -> Model
updateSelection model kbEvent =
    { filteredBookmarkGroups = model.filteredBookmarkGroups
    , selectedBookmarkGroupIndex =
        updatedIndex model.selectedBookmarkGroupIndex
            (List.length model.filteredBookmarkGroups)
            (selectionActionFromKeyboardEvent kbEvent "ArrowUp" "ArrowDown")
    , selectedBookmarkIndex =
        updatedIndex model.selectedBookmarkIndex
            (Maybe.withDefault 0 (Maybe.map (\bmg -> List.length bmg.bookmarks) (selectedBookmarkGroup model)))
            (selectionActionFromKeyboardEvent kbEvent "ArrowLeft" "ArrowRight")
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


selectedBookmarkGroup : Model -> Maybe BookmarkGroup
selectedBookmarkGroup model =
    getByIndex model.selectedBookmarkGroupIndex model.filteredBookmarkGroups


selectedBookmark : Model -> Maybe Bookmark
selectedBookmark model =
    case selectedBookmarkGroup model of
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
