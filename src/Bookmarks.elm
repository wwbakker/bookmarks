module Bookmarks exposing (Bookmark, bookmark, unfilteredBookmarks)


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



--group : String -> List Bookmark -> BookmarkGroup
--group caption bookmarks =
--    { caption = caption
--    , bookmarks = bookmarks
--    }


groups : List BookmarkGroup
groups =
    [ { caption = "Google"
      , bookmarks =
            [ bookmark "Google" "https://www.google.nl"
            , bookmark "Gmail" "http://mail.google.com"
            ]
      }
    ]


unfilteredBookmarks : List Bookmark
unfilteredBookmarks =
    [ bookmark "Google" "https://www.google.nl"
    , bookmark "Tweakers" "https://www.tweakers.net"
    ]
