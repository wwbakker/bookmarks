module Dom exposing (SelectionIndex, bookmarkGroupsToHtml, css)

import Bookmarks exposing (Bookmark, BookmarkGroup)
import Html exposing (..)
import Html.Attributes exposing (..)


type alias SelectionIndex =
    Int


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


bookmarkToHtml : ( Bookmark, IsSelected ) -> Html msg
bookmarkToHtml ( bm, isSelected ) =
    div [ classList [ ( "bookmark", True ), ( "selected", isSelected ) ] ]
        [ a [ href bm.href ] [ text bm.caption ]
        ]


bookmarkGroupHeader : BookmarkGroup -> Html msg
bookmarkGroupHeader _ =
    div [] []


swapTuple : ( a, b ) -> ( b, a )
swapTuple ( x, y ) =
    ( y, x )


type alias IsSelected =
    Bool


applySelection : List a -> SelectionIndex -> List ( a, IsSelected )
applySelection bm si =
    let
        bookmarksWithIndices : List ( Int, a )
        bookmarksWithIndices =
            List.indexedMap Tuple.pair bm

        isSelected : Int -> IsSelected
        isSelected i =
            i == si
    in
    List.map swapTuple (List.map (Tuple.mapFirst isSelected) bookmarksWithIndices)


deselectedBookmark : Bookmark -> ( Bookmark, Bool )
deselectedBookmark bm =
    ( bm, False )


applyBookmarksSelection : IsSelected -> SelectionIndex -> List Bookmark -> List ( Bookmark, IsSelected )
applyBookmarksSelection groupIsSelected selectedBookmarkIndex bookmarks =
    if groupIsSelected then
        -- if the group is selected, the selectedBookmarkIndex applies to the bookmark in this group
        applySelection bookmarks selectedBookmarkIndex

    else
        -- if the group is not selected, the selectedBookmarkIndex applies to the bookmark of another group
        List.map deselectedBookmark bookmarks


bookmarkGroupToHtml : ( BookmarkGroup, IsSelected ) -> SelectionIndex -> Html msg
bookmarkGroupToHtml ( bookmarkGroup, groupIsSelected ) selectedBookmarkIndex =
    div [ classList [ ( "bookmark-group", True ), ( "selected", groupIsSelected ) ] ]
        (bookmarkGroupHeader bookmarkGroup
            :: (bookmarkGroup.bookmarks
                    |> applyBookmarksSelection groupIsSelected selectedBookmarkIndex
                    |> List.map bookmarkToHtml
               )
        )


bookmarkGroupsToHtml : List BookmarkGroup -> SelectionIndex -> SelectionIndex -> List (Html msg)
bookmarkGroupsToHtml bookmarkGroups selectedGroup selectedBookmark =
    let
        bookmarkGroupsWithIsSelected : List ( BookmarkGroup, IsSelected )
        bookmarkGroupsWithIsSelected =
            applySelection bookmarkGroups selectedGroup
    in
    List.map (\bookmarkGroupWithIsSelected -> bookmarkGroupToHtml bookmarkGroupWithIsSelected selectedBookmark) bookmarkGroupsWithIsSelected
