module DataModel exposing (Bookmark, BookmarkGroup, Model, SelectionIndex)


type alias BookmarkGroup =
    { caption : String
    , bookmarks : List Bookmark
    }


type alias Bookmark =
    { caption : String
    , href : String
    }


type alias Model =
    { filteredBookmarkGroups : List BookmarkGroup, selectedBookmarkGroupIndex : SelectionIndex, selectedBookmarkIndex : SelectionIndex }


type alias SelectionIndex =
    Int
