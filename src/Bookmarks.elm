module Bookmarks exposing (Bookmark, BookmarkGroup, bookmark, unfilteredBookmarks)


type alias BookmarkGroup =
    { caption : String
    , bookmarks : List Bookmark
    }


type alias Bookmark =
    { caption : String
    , href : String
    }


bookmark : String -> String -> Bookmark
bookmark caption href =
    { caption = caption, href = href }


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


unfilteredBookmarks : List Bookmark
unfilteredBookmarks =
    List.concatMap (\l -> l.bookmarks) groups
