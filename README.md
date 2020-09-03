# KaTeX for Elm

Create strings or HTML elements with math using the [Kahn Academy's KaTeX javascript library](https://khan.github.io/KaTeX/).

__No ports are necessary__, but the KaTeX library must be loaded in the event loop. See _§Loading KaTeX_ at the bottom for details.

## The layout of this Elm package

There are four modules in this package: `Katex`, `Katex.Configs.Math`, `Katex.Configs.Human`, and `Katex.Configs`. They all perform the same task, but at different levels of customizability.

They all contain alike LaTeX instance creators:

* `human` - for writing regular text
* `inline` - for writing LaTeX code in inline math environment
* `display`- for writing LaTeX code in display math environment

and alike processors for showing LaTeX:

* `print` - for turning a LaTeX instance into a string
* `generate` - for generating functions that process LaTeX

The only difference between the modules is their simplicity-versatility tade-off.

## How it works

We use `human` for writing regular text, and `inline`/`display` to write LaTeX code in inline/display math environment. These all return LaTeX instances.

Each such LaTeX instance can be `print`ed to a string (which the KaTeX library will recognize and parse after Elm loads). More generally, you can `generate` a function which parses LaTeX instances into anything.

## Working examples

We will start with the simplest module, then show what can be done with the others.

### Katex

In this example we use `generate` to create an HTML emitting function which puts display math in a `div`, but inline math and human text in a `span`.

```elm
module Examples.Simple exposing (main)

import Html as H exposing (Html)
import Katex as K
    exposing
        ( Latex
        , human
        , inline
        , display
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
        , update = flip always
        , view = always view
        }
```

### Katex.Configs.Math

In this module we can configure how `m`ath code is parsed. In the following example, we use this functionality to replace `\phi` with `\varphi`, depending on the model.

```elm
module Examples.Configs.Math exposing (main)

import Html as H exposing (Html)
import Regex exposing (HowMany(All), regex, escape, replace)
import Katex.Configs.Math as K
    exposing
        ( Latex
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
        , update = flip always
        , view = view
        }
```

### Katex.Configs.Human

In this module we can configure how `h`uman text is parsed. In the following example, we use this functionality to switch between Hebrew and English, depending on the model.

```elm
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
```

### Katex.Configs

In this module we can configure how both `m`ath code and `h`uman text are parsed - a combination of the previous modules.

## Loading KaTeX

Beyond the need to load the KaTeX library (both `css` and `js`), the KaTeX script must run after Elm has loaded the text. The minimal example below of a working page should explain this concept in practice.

```html
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
    <style>
        /* LaTeX display environment will effect the LaTeX characters but not the layout on the page */
        span.katex-display {
          display: inherit; /* You may comment this out if you want the default behavior */
        }
      </style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.12.0/dist/katex.min.css" integrity="sha384-AfEj0r4/OFrOo5t7NnNe46zW/tFgW6x/bCJG8FqQCEo3+Aro6EYUG4+cU+KJWu/X" crossorigin="anonymous">
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.12.0/dist/katex.min.js" integrity="sha384-g7c+Jr9ZivxKLnZTDUhnkOnsh30B4H0rpLUpJ4jAIKs4fnJI+sEnkvrMWph2EDg4" crossorigin="anonymous"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.12.0/dist/contrib/auto-render.min.js" integrity="sha384-mll67QQFJfxn0IYznZYonOWZ644AWYC+Pt2cHqMaRhXVrursRwvLnLaebdGIlYNa" crossorigin="anonymous"
      onload="renderMathInElement(document.body);"></script>
    <script src="main.js"></script>
    <title></title>
  </head>
  <body>
    <div id="myapp"></div>

    <!-- Run the app + render LaTeX using KaTeX (note the seperate script tags!) -->
    <script>
        var app = Elm.Main.init({
          node: document.getElementById('myapp'),
          flags: Date.now()
        });
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
        renderMathInElement(document.body, {
          delimiters: [
            {
              left: "$begin-inline$", 
              right: "$end-inline$", 
              display: false
            }, 
            {
              left: "$begin-display$",
              right: "$end-display$", 
              display: true
            }]});
        });
    </script>
  </body>
</html>
```
