module PublicBookmarks exposing (bookmarkGroups)

import Bookmarks exposing (Bookmark, BookmarkGroup, bookmark)
import PrivateBookmarks exposing (privateGroups)


publicBookmarkGroups : List BookmarkGroup
publicBookmarkGroups =
    [ { caption = "Google"
      , bookmarks =
            [ bookmark "Google" "http://www.google.nl/"
            , bookmark "Gmail" "http://mail.google.com"
            , bookmark "Calendar" "http://calendar.google.com"
            , bookmark "Drive" "http://drive.google.com/"
            ]
      }
    ]


bookmarkGroups : List BookmarkGroup
bookmarkGroups =
    privateGroups ++ publicBookmarkGroups
