module Examples.Configs.Human exposing (main)

import Html as H exposing (Html)
import Html.Attributes exposing (dir)
import Katex.Configs.Human as K
    exposing
        ( Latex
        , inline
        , display
        )


type alias Config =
    Bool


type alias Data =
    ( String, String )


selector : Data -> Config -> String
selector ( english, hebrew ) isHeb =
    if isHeb then
        hebrew
    else
        english


human : Data -> Latex Config
human =
    K.human << selector


passage : List (Latex Config)
passage =
    [ human
        ( "We denote by "
        , "נסמן ב "
        )
    , inline "\\phi"
    , human
        ( " the formula for which "
        , " את הנוסחה עבורה "
        )
    , display "\\Gamma \\vDash \\phi"
    , human
        ( "."
        , "."
        )
    ]


view : Config -> Html a
view isHeb =
    let
        direction =
            if isHeb then
                dir "rtl"
            else
                dir "ltr"

        htmlGenerator _ _ stringLatex =
            H.span [] [ H.text stringLatex ]
    in
        passage
            |> List.map (K.generate htmlGenerator isHeb)
            |> H.div [ direction ]


main : Program Never Config msg
main =
    H.beginnerProgram
        { model = True
        , update = flip always
        , view = view
        }
