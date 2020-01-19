module Util where

import Prelude
import Effect (Effect)
import Data.String as String
import Prim.Row (class Union, class Nub)
import React (ReactClass)
import React as React
import React.Basic (JSX, toReactComponent)
import React.Basic as RB
import React.Basic.DOM (CSS)
import React.Basic.DOM.Generated (Props_div)
import Record as Record
import Unsafe.Coerce (unsafeCoerce)

toBasic ::
  forall props.
  ReactClass { children :: React.Children | props } ->
  { children :: Array JSX | props } -> JSX
toBasic reactClass props =
  RB.element (unsafeCoerce reactClass)
    ( props
    )

toBasicLeaf ::
  forall props.
  ReactClass { | props } ->
  { | props } -> JSX
toBasicLeaf reactClass props =
  RB.element (unsafeCoerce reactClass)
    ( props
    )

type Patch r
  = forall r1 r2.
    Union
      r1
      r
      r2 =>
    { | r1 } -> { | r2 }

type PatchStyle
  = Patch
      ( className :: String
      , style :: CSS
      )

type Style
  = { css :: CSS
    , classNames :: Array String
    }

style_toProps :: Style -> { style :: CSS, className :: String }
style_toProps style =
  { style: style.css
  , className: String.joinWith " " style.classNames
  }

patchStyle :: forall r. Style -> { | r } -> { style :: CSS, className :: String | r }
patchStyle style r =
  Record.union
    { style: style.css
    , className: String.joinWith " " style.classNames
    }
    r
