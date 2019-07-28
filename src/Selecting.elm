module Selecting exposing (selectedBookmark, updateSelection)

import Array
import DataModel exposing (Bookmark, BookmarkGroup, Model, SelectionIndex)
import Keyboard.Event exposing (KeyboardEvent)
import Regex


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


selectedBookmarkGroup : Model -> Maybe BookmarkGroup
selectedBookmarkGroup model =
    getByIndex model.selectedBookmarkGroupIndex model.filteredBookmarkGroups


getByIndex : Int -> List a -> Maybe a
getByIndex index list =
    Array.get index (Array.fromList list)


selectedBookmark : Model -> Maybe Bookmark
selectedBookmark model =
    case selectedBookmarkGroup model of
        Nothing ->
            Nothing

        Just bmg ->
            getByIndex model.selectedBookmarkIndex bmg.bookmarks


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
