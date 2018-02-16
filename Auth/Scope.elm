module Auth.Scope exposing (Scope(..), toString)


type Scope
    = Read
    | Write
    | Follow


toString : Scope -> String
toString scope =
    case scope of
        Read ->
            "read"

        Write ->
            "write"

        Follow ->
            "follow"
