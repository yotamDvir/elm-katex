module Katex.Configs.Human
    exposing
        ( Latex
        , human
        , inline
        , display
        , print
        , generate
        )

{-| You should use this module only if you need `h`uman configurations.

_Understand `Katex` before reading on._

### Why is this module necessary?

For example, let's say you want your lecture notes in both English and Hebrew. In this case, you can write both and show whichever you want, depending on the state of your app. See _§Katex.Configs.Human_ in the README for this example in action.

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
type alias Latex h =
    K.Latex String h


{-| Like `Katex.human`, but instead of feeding it a string, you feed it a `h`uman-dependent string.
-}
human : (h -> String) -> Latex h
human =
    K.human


{-| Like `Katex.inline`.
-}
inline : String -> Latex h
inline =
    K.inline << always


{-| Like `Katex.display`.
-}
display : String -> Latex h
display =
    K.display << always


{-| Like `Katex.print`, but depends on the `h`uman configurations.
-}
print : h -> Latex h -> String
print =
    generate (\_ _ -> identity)


{-| Like `Katex.generate`, but depends on the `h`uman configurations. The generating function has access to the `h`uman configurations, but this is usually unnecessary, in which case simply use a generating function which ignores its first argument.
-}
generate : (h -> Maybe Bool -> String -> a) -> h -> Latex h -> a
generate g h =
    K.generate (\_ h -> g h) "" h
