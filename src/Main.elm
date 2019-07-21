module Main exposing (Model, Msg(..), bookmarkToHtml, bookmarksFilter, init, main, update, view)

import Array
import Bookmarks exposing (Bookmark, unfilteredBookmarks)
import Browser
import Browser.Navigation exposing (load)
import Debug exposing (log)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onInput)
import Json.Decode
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)


main =
    Browser.element { init = \() -> init, view = view, update = update, subscriptions = \_ -> Sub.none }


css : String
css =
    """
body {
    background-color: #ddd;
}

h1 {
    border-bottom: .2em dashed black;
}
.bookmark {
}
.bookmark.selected {
    font-weight: bold;
}
"""


type alias Model =
    { filteredBookmarks : List Bookmark, selectionIndex : SelectionIndex }


init : ( Model, Cmd message )
init =
    ( { filteredBookmarks = unfilteredBookmarks
      , selectionIndex = 0
      }
    , Cmd.none
    )


type Msg
    = Filter String
    | HandleKeyboardEvent KeyboardEvent


type alias SelectionIndex =
    Int


bookmarkToHtml : ( Bookmark, Bool ) -> Html Msg
bookmarkToHtml ( bm, isSelected ) =
    li []
        [ a [ href bm.href, classList [ ( "bookmark", True ), ( "selected", isSelected ) ] ] [ text bm.caption ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Filter newFilterString ->
            ( { model
                | filteredBookmarks = List.filter (bookmarksFilter newFilterString) unfilteredBookmarks
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
        | selectionIndex =
            case kbEvent.key of
                Just key ->
                    if key == "ArrowDown" then
                        modBy (List.length model.filteredBookmarks) (model.selectionIndex + 1)

                    else if key == "ArrowUp" then
                        if (model.selectionIndex - 1) < 0 then
                            List.length model.filteredBookmarks - 1

                        else
                            model.selectionIndex - 1

                    else
                        0

                Nothing ->
                    model.selectionIndex
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
    Array.get model.selectionIndex (Array.fromList model.filteredBookmarks)


bookmarksFilter : String -> Bookmark -> Bool
bookmarksFilter filterString bm =
    if filterString == "" then
        True

    else if String.startsWith (String.toLower filterString) (String.toLower bm.caption) then
        True

    else
        False


bookmarksAndSelection : List Bookmark -> SelectionIndex -> List ( Bookmark, Bool )
bookmarksAndSelection bm si =
    let
        bookmarksWithIndices : List ( Int, Bookmark )
        bookmarksWithIndices =
            List.indexedMap Tuple.pair bm

        isSelected : Int -> Bool
        isSelected i =
            i == si
    in
    List.map swapTuple (List.map (Tuple.mapFirst isSelected) bookmarksWithIndices)


swapTuple : ( a, b ) -> ( b, a )
swapTuple ( x, y ) =
    ( y, x )


view : Model -> Html Msg
view model =
    div
        []
        [ Html.node "style" [] [ text css ]
        , ul [] (List.map bookmarkToHtml (bookmarksAndSelection model.filteredBookmarks model.selectionIndex))
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
