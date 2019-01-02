module Examples.Simple exposing (main)

import Html as H exposing (Html)
import Katex as K
    exposing
        ( Latex
        , display
        , human
        , inline
        )


passage : List Latex
passage =
    [ human "We denote by "
    , inline "\\phi"
    , human " the formula for which "
    , display "\\Gamma \\vDash \\phi"
    ]


view : Html a
view =
    let
        htmlGenerator isDisplayMode stringLatex =
            case isDisplayMode of
                Just True ->
                    H.div [] [ H.text stringLatex ]

                _ ->
                    H.span [] [ H.text stringLatex ]
    in
    passage
        |> List.map (K.generate htmlGenerator)
        |> H.div []


main : Program Never () msg
main =
    H.beginnerProgram
        { model = ()
        , update = \b a -> always a b
        , view = always view
        }
