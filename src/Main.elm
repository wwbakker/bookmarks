module Main exposing (Bookmark, Model, Msg(..), bookmark, bookmarkToHtml, bookmarksFilter, init, main, unfilteredBookmarks, update, view)

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


type alias Bookmark =
    { href : String
    , caption : String
    }


type alias SelectionIndex =
    Int


bookmark : String -> String -> Bookmark
bookmark href caption =
    { href = href, caption = caption }


bookmarkToHtml : ( Bookmark, Bool ) -> Html Msg
bookmarkToHtml ( bm, isSelected ) =
    li []
        [ a [ href bm.href, classList [ ( "bookmark", True ), ( "selected", isSelected ) ] ] [ text bm.caption ]
        ]


unfilteredBookmarks : List Bookmark
unfilteredBookmarks =
    [ bookmark "https://www.google.nl" "Google"
    , bookmark "https://www.tweakers.net" "Tweakers"
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
            ( { model
                | selectionIndex =
                    case event.key of
                        Just key ->
                            if log "key" key == "ArrowDown" then
                                model.selectionIndex + 1

                            else if key == "ArrowUp" then
                                model.selectionIndex - 1

                            else
                                model.selectionIndex

                        Nothing ->
                            model.selectionIndex
              }
            , case event.key of
                Just key ->
                    if key == "Enter" then
                        load "https://www.google.nl"

                    else
                        Cmd.none

                Nothing ->
                    Cmd.none
            )


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
        --    [ button [ onClick Decrement ] [ text "-" ]
        --    , div [] [ text (String.fromInt model) ]
        --    , button [ onClick Increment ] [ text "+" ]
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
