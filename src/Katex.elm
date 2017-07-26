module Katex
    exposing
        ( Latex
        , human
        , inline
        , display
        , print
        , generate
        )

{-| You should use this module if this is your first time using this package, or if you don't need special configurations.

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
type alias Latex =
    K.Latex String String


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


{-| Turn a LaTeX instance into a string that the KaTeX library recognizes.
-}
print : Latex -> String
print =
    generate (\_ -> identity)


{-| Generate a function over LaTeX values. The boolean value represents whether the math is in display mode, i.e.

* `Nothing` for human
* `Just False` for inline
* `Just True` for display

For example, let's say you want an `Html a` emitting function which puts display math in a `div`, but inline math and human text in a `span`.

    view : Latex -> Html a
    view =
        let
            htmlGenerator isDisplayMode stringLatex =
                case isDisplayMode of
                    Just True ->
                        H.div [] [ H.text stringLatex ]
                    _ ->
                        H.span [] [ H.text stringLatex ]
        in
            generate htmlGenerator

Another example is the built-in `print` function.

    print : Latex -> String
    print =
        generate (\_ stringLatex -> stringLatex)
-}
generate : (Maybe Bool -> String -> a) -> Latex -> a
generate g =
    K.generate (\_ _ -> g) "" ""
