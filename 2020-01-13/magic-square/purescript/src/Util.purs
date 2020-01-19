module Util where

import Prelude
import React (ReactClass)
import React as React
import React.Basic (JSX, toReactComponent)
import React.Basic as RB
import Unsafe.Coerce (unsafeCoerce)
import Record as Record
import Prim.Row (class Union, class Nub)
import React.Basic.DOM.Generated (Props_div)
import Effect (Effect)

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
  = forall r1 r2 r3.
    Nub r2 r3 =>
    Union r1 r r2 =>
    { | r1 } -> { | r3 }
