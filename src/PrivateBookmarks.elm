module PrivateBookmarks exposing (privateGroups, privateBookmarks)

import Bookmarks exposing (Bookmark, BookmarkGroup, bookmark)


privateGroups : List BookmarkGroup
privateGroups =
    []


privateBookmarks : List Bookmark
privateBookmarks =
    List.concatMap (\l -> l.bookmarks) privateGroups
