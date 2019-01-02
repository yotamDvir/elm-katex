module Examples.Configs.Math exposing (main)

import Html as H exposing (Html)
import Katex.Configs.Math as K
    exposing
        ( Latex
        , human
        )
import Regex exposing (HowMany(..), escape, regex, replace)


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


passage : List (Latex Config)
passage =
    [ human "We denote by "
    , inline "\\phi"
    , human " the formula for which "
    , display "\\Gamma \\vDash \\phi"
    ]


view : Config -> Html a
view isVar =
    let
        htmlGenerator _ _ stringLatex =
            H.span [] [ H.text stringLatex ]
    in
    passage
        |> List.map (K.generate htmlGenerator isVar)
        |> H.div []


main : Program Never Config msg
main =
    H.beginnerProgram
        { model = True
        , update = \b a -> always a b
        , view = view
        }
