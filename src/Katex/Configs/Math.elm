module Katex.Configs.Math
    exposing
        ( Latex
        , human
        , inline
        , display
        , print
        , generate
        )

{-| You should use this module only if you need `m`ath configurations.

_Understand `Katex` before reading on._

### Why is this module necessary?

For example, let's say you are not sure which of `\phi` and `\varphi` you prefer.
In this case, you can write code with `\phi` which may be replaced depending on your configuration. See _§Katex.Configs.Math_ in the README for this example in action.

# Types
@docs Latex

# Create LaTeX instance
@docs human, inline, display

# Process LaTeX instances
@docs print, generate
-}

import Katex.Configs as K


{-| A LaTeX instance.
-}
type alias Latex m =
    K.Latex m String


{-| Like `Katex.human`.
-}
human : String -> Latex m
human =
    K.human << always


{-| Like `Katex.inline`, but instead of feeding it a string, you feed it a `m`ath-dependent string.
-}
inline : (m -> String) -> Latex m
inline =
    K.inline


{-| Like `Katex.display`, but instead of feeding it a string, you feed it a `m`ath-dependent string.
-}
display : (m -> String) -> Latex m
display =
    K.display


{-| Like `Katex.print`, but depends on the `m`ath configurations.
-}
print : m -> Latex m -> String
print =
    generate (\_ _ -> identity)


{-| Like `Katex.generate`, but depends on the `m`ath configurations. The generating function has access to the `m`ath configurations, but this is usually unnecessary, in which case simply use a generating function which ignores its first argument.
-}
generate : (m -> Maybe Bool -> String -> a) -> m -> Latex m -> a
generate g m =
    K.generate (\m _ -> g m) m ""
