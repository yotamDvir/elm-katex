module Katex.Configs
    exposing
        ( Latex
        , human
        , inline
        , display
        , print
        , generate
        )

{-| You should use this module only if you need both `m`ath and `h`uman configurations.

_Understand `Katex.Configs.Math` and `Katex.Configs.Human` before reading on._

### Why is this module necessary?

You may need both types of configurations (`m`ath and `h`uman).

# Types
@docs Latex

# Create LaTeX instance
@docs human, inline, display

# Process LaTeX instances
@docs print, generate
-}


{-| A LaTeX instance.
-}
type Latex m h
    = Human (h -> String)
    | Math Bool (m -> String)


{-| Like `Katex.Configs.Human.human`.
-}
human : (h -> String) -> Latex m h
human =
    Human


{-| Like `Katex.Configs.Math.inline`.
-}
inline : (m -> String) -> Latex m h
inline =
    Math False


{-| Like `Katex.Configs.Math.display`.
-}
display : (m -> String) -> Latex m h
display =
    Math True


{-| Like `Katex.print`, but depends on the `m`ath and `h`uman configurations.
-}
print : m -> h -> Latex m h -> String
print =
    generate (\_ _ _ -> identity)


{-| Like `Katex.generate`, but depends on the `m`ath and `h`uman configurations. The generating function has access to the `m`ath and `h`uman configurations, but this is usually unnecessary, in which case simply use a generating function which ignores its first arguments.
-}
generate : (m -> h -> Maybe Bool -> String -> a) -> m -> h -> Latex m h -> a
generate g m h latex =
    let
        g_ =
            g m h
    in
        case latex of
            Human f ->
                f h
                    |> g_ Nothing

            Math b f ->
                let
                    env =
                        if b then
                            "display"
                        else
                            "inline"
                in
                    ("$begin-" ++ env ++ "$" ++ f m ++ "$end-" ++ env ++ "$")
                        |> g_ (Just b)
