module Katex.Backend
    exposing
        ( Latex
        , Passage
        , view
        , compile
        , human
        , inline
        , display
        )

import Html exposing (Html)


type Latex config lang
    = HumanString (lang -> String)
    | InlineString (config -> String)
    | DisplayString (config -> String)


type alias Passage config lang =
    List (Latex config lang)


view : config -> lang -> Passage config lang -> Html a
view config lang =
    List.map (compile config lang)
        >> String.join ""
        >> Html.text


compile : config -> lang -> Latex config lang -> String
compile config lang latex =
    case latex of
        HumanString f ->
            f lang

        InlineString f ->
            "$begin-inline$" ++ f config ++ "$end-inline$"

        DisplayString f ->
            "$begin-display$" ++ f config ++ "$end-display$"


human : (lang -> String) -> Latex config lang
human =
    HumanString


inline : (config -> String) -> Latex config lang
inline =
    InlineString


display : (config -> String) -> Latex config lang
display =
    DisplayString
