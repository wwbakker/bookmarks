module PublicBookmarks exposing (publicBookmarks, bookmarks)

import Bookmarks exposing (Bookmark, BookmarkGroup, bookmark)
import PrivateBookmarks exposing (privateBookmarks)

groups : List BookmarkGroup
groups =
    [ { caption = "Google"
      , bookmarks =
            [ bookmark "Google" "http://www.google.nl/"
            , bookmark "Gmail" "http://mail.google.com"
            , bookmark "Calendar" "http://calendar.google.com"
            , bookmark "Drive" "http://drive.google.com/"
            ]
      }
    ]


publicBookmarks : List Bookmark
publicBookmarks =
    List.concatMap (\l -> l.bookmarks) groups

bookmarks : List Bookmark
bookmarks = privateBookmarks ++ publicBookmarks