module Bookmarks exposing (Bookmark, BookmarkGroup, bookmark)

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
