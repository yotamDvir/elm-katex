module Katex.Lang
    exposing
        ( Latex
        , Passage
        , view
        , compile
        , human
        , inline
        , display
        )

{-| If you want to write in different languages simultaneously, you should use `lang`. _Understand `Katex.Simple` before reading on._

For example, let's say you want your notes in both English and Hebrew. In this case, you can write both and show whichever you want, depending on the state of your app. See _§Lang_ in the README for this example in action.

# Types
@docs Latex, Passage
Note that `lang` is a type variable, you may use whichever type fits your needs.

# Create LaTeX instance
@docs human, inline, display

# Process LaTeX instances
@docs view, compile
-}

import Html exposing (Html)
import Katex.Backend as K


{-| A list of LaTeX instances.
-}
type alias Passage lang =
    K.Passage String lang


{-| A LaTeX instance.
-}
type alias Latex lang =
    K.Latex String lang


{-| Like `Katex.Simple.view`, but depends on the `lang`uage.
-}
view : lang -> Passage lang -> Html a
view lang =
    K.view "" lang


{-| Like `Katex.Simple.compile`, but depends on the `lang`uage.
-}
compile : lang -> Latex lang -> String
compile lang =
    K.compile "" lang


{-| Like `Katex.Simple.human`, but instead of feeding it a string, you must feed it a `lang`uage-dependent string.
-}
human : (lang -> String) -> Latex lang
human =
    K.human


{-| Like `Katex.Simple.inline`.
-}
inline : String -> Latex lang
inline =
    K.inline << always


{-| Like `Katex.Simple.display`.
-}
display : String -> Latex lang
display =
    K.display << always
