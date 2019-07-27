module Filtering exposing (filterBookmarkGroups)

import Bookmarks exposing (Bookmark, BookmarkGroup)
import List.Extra exposing (uniqueBy)


bookmarkStartsWith : String -> Bookmark -> Bool
bookmarkStartsWith filterString bm =
    String.startsWith (String.toLower filterString) (String.toLower bm.caption)


bookmarkContains : String -> Bookmark -> Bool
bookmarkContains filterString bm =
    String.contains (String.toLower filterString) (String.toLower bm.caption)


filterBookmarks : String -> List Bookmark -> List Bookmark
filterBookmarks newFilterString bms =
    (List.filter (bookmarkStartsWith newFilterString) bms
        ++ List.filter (bookmarkContains newFilterString) bms
    )
        |> uniqueBy (\bm -> bm.href)


filterBookmarkGroup : String -> BookmarkGroup -> BookmarkGroup
filterBookmarkGroup newFilterString bookmarkGroup =
    { bookmarkGroup | bookmarks = filterBookmarks newFilterString bookmarkGroup.bookmarks }


filterBookmarkGroups : String -> List BookmarkGroup -> List BookmarkGroup
filterBookmarkGroups newFilterString bookmarkGroupList =
    let
        filteredBmgs : List BookmarkGroup
        filteredBmgs =
            List.map (\bmg -> filterBookmarkGroup newFilterString bmg) bookmarkGroupList
    in
    List.filter (\fbmg -> List.isEmpty fbmg.bookmarks) filteredBmgs
