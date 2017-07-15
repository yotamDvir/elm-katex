module Katex.Config
    exposing
        ( Latex
        , Passage
        , view
        , compile
        , human
        , inline
        , display
        )

{-| If you want to apply macros to all math instances, you should use `Katex.Config`. _Understand `Katex.Simple` before reading on._

For example, let's say you are not sure which of `\phi` and `\varphi` you prefer.
In this case, you can write code with `\phi` which may be replaced depending on your configuration. See _§Config_ in the README for this example in action.

# Types
@docs Latex, Passage
Note that `config` is a type variable, you may use whichever type fits your needs.

# Create LaTeX instance
@docs human, inline, display

# Process LaTeX instances
@docs view, compile
-}

import Html exposing (Html)
import Katex.Backend as K


{-| A list of LaTeX instances.
-}
type alias Passage config =
    K.Passage config String


{-| A LaTeX instance.
-}
type alias Latex config =
    K.Latex config String


{-| Like `Katex.Simple.view`, but depends on the `config`uration.
-}
view : config -> Passage config -> Html a
view config =
    K.view config ""


{-| Like `Katex.Simple.compile`, but depends on the `config`uration.
-}
compile : config -> Latex config -> String
compile config =
    K.compile config ""


{-| Like `Katex.Simple.human`.
-}
human : String -> Latex config
human =
    K.human << always


{-| Like `Katex.Simple.inline`, but instead of feeding it a string, you must feed it a `config`uration-dependent string.
-}
inline : (config -> String) -> Latex config
inline =
    K.inline


{-| Like `Katex.Simple.display`, but instead of feeding it a string, you must feed it a `config`uration-dependent string.
-}
display : (config -> String) -> Latex config
display =
    K.display
