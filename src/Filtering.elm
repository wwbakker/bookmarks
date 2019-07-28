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


filterBookmarkGroupElements : String -> List BookmarkGroup -> List BookmarkGroup
filterBookmarkGroupElements newFilterString allBookmarkGroups =
    List.map (\bmg -> filterBookmarkGroup newFilterString bmg) allBookmarkGroups


filterNonEmptyBookmarkGroups : List BookmarkGroup -> List BookmarkGroup
filterNonEmptyBookmarkGroups bookmarkGroups =
    List.filter (\fbmg -> not (List.isEmpty fbmg.bookmarks)) bookmarkGroups


filterBookmarkGroups : String -> List BookmarkGroup -> List BookmarkGroup
filterBookmarkGroups newFilterString allBookmarkGroups =
    if String.trim newFilterString == "" then
        allBookmarkGroups

    else
        allBookmarkGroups
            |> filterBookmarkGroupElements newFilterString
            |> filterNonEmptyBookmarkGroups
