module Examples.Config exposing (main)

import Html exposing (Html)
import Regex exposing (HowMany(All), regex, escape, replace)
import Katex.Config as K
    exposing
        ( Latex
        , Passage
        , human
        )


type alias Config =
    Bool


type alias Data =
    String


selector : Data -> Config -> String
selector string isVar =
    let
        phi =
            string

        varphi =
            replace All (regex (escape "\\phi")) (always "\\varphi") string
    in
        if isVar then
            varphi
        else
            phi


inline : Data -> Latex Config
inline =
    K.inline << selector


display : Data -> Latex Config
display =
    K.display << selector


passage : Passage Config
passage =
    [ human "We denote by "
    , inline "\\phi"
    , human " the formula for which "
    , display "\\Gamma \\vDash \\phi"
    , human "."
    ]


view : Config -> Html a
view isVar =
    Html.div
        []
        [ K.view isVar passage
        ]


main : Program Never Config msg
main =
    Html.beginnerProgram
        { model = True
        , update = flip always
        , view = view
        }
