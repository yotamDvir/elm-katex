module Katex.Simple
    exposing
        ( Latex
        , Passage
        , view
        , compile
        , human
        , inline
        , display
        )

{-| Create strings or HTML elements with math using `Katex.Simple`.

# Types
@docs Latex, Passage

# Create LaTeX instance
@docs human, inline, display

# Process LaTeX instances
@docs view, compile
-}

import Html exposing (Html)
import Katex.Backend as K


{-| A list of LaTeX instances.
-}
type alias Passage =
    K.Passage String String


{-| A LaTeX instance.
-}
type alias Latex =
    K.Latex String String


{-| Processes a LaTeX passage (list of LaTeX instances) into a text node (parsable by the KaTeX library).
-}
view : Passage -> Html a
view =
    K.view "" ""


{-| For other scenarios, LaTeX instance can be `compile`d to a string.
-}
compile : Latex -> String
compile =
    K.compile "" ""


{-| Use `human` when writing regular text.
-}
human : String -> Latex
human =
    K.human << always


{-| Use `inline` when writing LaTeX code for inline math environment.
-}
inline : String -> Latex
inline =
    K.inline << always


{-| Use `display` when writing LaTeX code for display math environment.
-}
display : String -> Latex
display =
    K.display << always
