module Katex.Complex
    exposing
        ( Latex
        , Passage
        , view
        , compile
        , human
        , inline
        , display
        )

{-| If you need both `config`urations and `lang`uage dependencies, you should use `complex`. _Understand `Katex.Config` and `Katex.Lang` before reading on._

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
type alias Passage config lang =
    K.Passage config lang


{-| A LaTeX instance.
-}
type alias Latex config lang =
    K.Latex config lang


{-| Like `Katex.Simple.view`, but depends on the `config`uration and `lang`uage.
-}
view : config -> lang -> Passage config lang -> Html a
view =
    K.view


{-| Like `Katex.Simple.compile`, but depends on the `config`uration and `lang`uage.
-}
compile : config -> lang -> Latex config lang -> String
compile =
    K.compile


{-| Like `Katex.Lang.human`.
-}
human : (lang -> String) -> Latex config lang
human =
    K.human


{-| Like `Katex.Config.inline`.
-}
inline : (config -> String) -> Latex config lang
inline =
    K.inline


{-| Like `Katex.Config.display`.
-}
display : (config -> String) -> Latex config lang
display =
    K.display
