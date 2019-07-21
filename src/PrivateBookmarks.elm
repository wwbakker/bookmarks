module PrivateBookmarks exposing (privateGroups, unfilteredPrivateBookmarks)

import Bookmarks exposing (Bookmark, BookmarkGroup, bookmark)


privateGroups : List BookmarkGroup
privateGroups =
    []


unfilteredPrivateBookmarks : List Bookmark
unfilteredPrivateBookmarks =
    List.concatMap (\l -> l.bookmarks) privateGroups
