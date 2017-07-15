module Examples.Lang exposing (main)

import Html exposing (Html)
import Html.Attributes exposing (dir)
import Katex.Lang as K
    exposing
        ( Latex
        , Passage
        , inline
        , display
        )


type alias Language =
    Bool


type alias Data =
    ( String, String )


selector : Data -> Language -> String
selector ( english, hebrew ) isHeb =
    if isHeb then
        hebrew
    else
        english


human : Data -> Latex Language
human =
    K.human << selector


passage : Passage Language
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


view : Language -> Html a
view isHeb =
    Html.div
        [ if isHeb then
            dir "rtl"
          else
            dir "ltr"
        ]
        [ K.view isHeb passage
        ]


main : Program Never Language msg
main =
    Html.beginnerProgram
        { model = True
        , update = flip always
        , view = view
        }
