module Examples.Simple exposing (main)

import Html exposing (Html)
import Katex.Simple as K exposing (Latex, Passage, human, inline, display)


passage : Passage
passage =
    [ human "We denote by "
    , inline "\\phi"
    , human " the formula for which "
    , display "\\Gamma \\vDash \\phi"
    , human "."
    ]


view : Html a
view =
    Html.div
        []
        [ K.view passage
        ]


main : Program Never () msg
main =
    Html.beginnerProgram
        { model = ()
        , update = flip always
        , view = always view
        }
