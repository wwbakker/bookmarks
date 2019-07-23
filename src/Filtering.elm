module Filtering exposing (filteredBookmarks)

import Bookmarks exposing (Bookmark)
import PublicBookmarks exposing (bookmarks)
import List.Extra exposing (uniqueBy)

bookmarkStartsWith : String -> Bookmark -> Bool
bookmarkStartsWith filterString bm =
    String.startsWith (String.toLower filterString) (String.toLower bm.caption)

bookmarkContains : String -> Bookmark -> Bool
bookmarkContains filterString bm =
    String.contains (String.toLower filterString) (String.toLower bm.caption)

filteredBookmarks : String -> List Bookmark
filteredBookmarks newFilterString =
    (List.filter (bookmarkStartsWith newFilterString) bookmarks ++
                List.filter (bookmarkContains newFilterString) bookmarks)
                |> uniqueBy (\bm -> bm.href)
