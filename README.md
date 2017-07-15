# KaTeX for Elm

Create strings or HTML elements with math using the [Kahn Academy's KaTeX javascript library](https://khan.github.io/KaTeX/).

__No ports are necessary__, but the KaTeX library must be loaded in the event loop. See _§Loading KaTeX_ at the bottom for details.

## The layout of this Elm package

There are four modules which all perform the same basic task: `Simple`, `Config`, `Lang`, and `Complex`.

They all contain the same LaTeX instance creators:

* `human` - for writing regular text
* `inline` - for writing LaTeX code in inline math environment
* `display`- for writing LaTeX code in display math environment

and the same processors for showing LaTeX:

* `compile` - for turning a LaTeX instance into a string
* `view` - for joining a list of LaTeX instances (henceforth a passage) and turning it into an HTML text node

## How it works

We use `human` for writing regular text, and `inline`/`display` to write LaTeX code in inline/display math environment.

Each such LaTeX instance can be `compile`d to a string (which the KaTeX library will parse after Elm loads), but the most common usage is probably to turn a passage into a text node, which is what `view` does.

## Working examples

### Simple

In this example we simply want a LaTeX passage.

```elm
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
```

### Config

In the following we wish to replace `\phi` with `\varphi` depending on the model.

```elm
module Examples.Config exposing (main)

import Html exposing (Html)
import Regex exposing (HowMany(All), regex, escape, replace)
import Katex.Config as K exposing (Latex, Passage, human)


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
```

### Lang

Here we wish to write our LaTeX passage in Hebrew as well as in English.

```elm
module Examples.Lang exposing (main)

import Html exposing (Html)
import Html.Attributes exposing (dir)
import Katex.Lang as K exposing (Latex, Passage, inline, display)


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
```

### Complex

This is simply in case you need the functionalities of both `Lang` and `Config`.

## Loading KaTeX

Beyond the need to load the KaTeX library (both `css` and `js`), the KaTeX script must run after Elm has loaded the text. The minimal example below of a working page should explain this concept in practice.

```html
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.css" integrity="sha384-wITovz90syo1dJWVh32uuETPVEtGigN07tkttEqPv+uR2SE/mbQcG7ATL28aI9H0" crossorigin="anonymous">
    <style>
      /* LaTeX display environment will effect the LaTeX characters but not the layout on the page */
      span.katex-display {
        display: inherit; /* You may comment this out if you want the default behavior */
      }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.js" integrity="sha384-/y1Nn9+QQAipbNQWU65krzJralCnuOasHncUFXGkdwntGeSvQicrYkiUBwsgUqc1" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/contrib/auto-render.min.js" integrity="sha384-dq1/gEHSxPZQ7DdrM82ID4YVol9BYyU7GbWlIwnwyPzotpoc57wDw/guX8EaYGPx" crossorigin="anonymous"></script>
    <title></title>
  </head>
  <body>
    <!-- Exposing `Elm.Main` -->
    <script src="main.js"></script>
    <!-- Run the app + render LaTeX using KaTeX (note the `setTimeout`!) -->
    <script>Elm.Main.fullscreen(); setTimeout(function () {
      renderMathInElement(document.body, {delimiters: [{left: "$begin-inline$", right: "$end-inline$", display: false},{left: "$begin-display$", right: "$end-display$", display: true}]});
    }, 0);</script>
  </body>
</html>
```
