module PublicBookmarks exposing (bookmarkGroups)

import DataModel exposing (Bookmark, BookmarkGroup)
import PrivateBookmarks exposing (privateGroups)


publicBookmarkGroups : List BookmarkGroup
publicBookmarkGroups =
    [ { caption = "Google"
      , bookmarks =
            [ Bookmark "Google" "http://www.google.nl/"
            , Bookmark "Gmail" "http://mail.google.com"
            , Bookmark "Calendar" "http://calendar.google.com"
            , Bookmark "Drive" "http://drive.google.com/"
            ]
      }
    ]


bookmarkGroups : List BookmarkGroup
bookmarkGroups =
    privateGroups ++ publicBookmarkGroups
