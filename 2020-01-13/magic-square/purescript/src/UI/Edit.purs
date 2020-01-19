module UI.Edit (ui) where

import Prelude
import BaseUI.Slider.Marks as Slider.Marks
import BaseUI.Slider as BaseUI.Slider
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Matrix.Extra as Matrix
import Data.Maybe (Maybe(..), fromJust)
import Data.Maybe (maybe)
import Data.Typelevel.Num (class Pos, class Succ, d1, d5, reifyInt, reifyIntP)
import Data.Typelevel.Num as N
import Data.Typelevel.Num.Ops (succ, class SuccP)
import Data.Typelevel.Num.Reps (type (:*))
import Data.Typelevel.Undefined (undefined)
import Effect (Effect)
import Effect.Console (log)
import MagicSquare.OddNatural (class Odd)
import MagicSquare.OddNatural as MagicSquare.OddNatural
import Matrix (Matrix)
import Partial.Unsafe (unsafeCrashWith, unsafePartial)
import React (ReactClass)
import React as React
import React.Basic (Component, JSX, createComponent, element, make)
import React.Basic as RB
import React.Basic.DOM as R
import React.Basic.DOM.Events (capture_)
import React.DOM as DOM
import Unsafe.Coerce (unsafeCoerce)
import Util (toBasic, toBasicLeaf)
import BaseUI.Card as BaseUI.Card
import BaseUI.Button as BaseUI.Button

ui :: Props -> JSX
ui = mkUi render

-- Control.Types
--
type Props
  = { builders ::
      { value :: Maybe (NonEmptyArray (Matrix (Maybe Int)))
      , onChange :: NonEmptyArray (Matrix (Maybe Int)) -> Effect Unit
      }
    }

type State
  = { size :: Int }

data Action
  = Submit
  | SetSize Int

type Render
  = (Action -> Effect Unit) -> State -> Props -> JSX

-- Control
--
action :: _ -> Action -> Effect Unit
action self action = case action of
  Submit ->
    maybe (pure unit)
      self.props.builders.onChange
      (MagicSquare.OddNatural.solve_steps' self.state.size)
  SetSize n -> self.setState _ { size = n }

initialState :: State
initialState = { size: 5 }

mkUi :: Render -> Props -> JSX
mkUi render =
  make (createComponent "Edit")
    { initialState
    , render: \self -> render (action self) self.state self.props
    }

-- Markup
--
render :: Render
render action state props =
  let
    marks start =
      Slider.Marks.create
        { min: 1
        , start
        , end: Nothing
        , max: 30 + 1
        , step: 2
        }
  in
    toBasic BaseUI.Card.card
      { title: "Odd Natural"
      , children:
        [ toBasic BaseUI.Card.styledBody
            { children:
              [ toBasicLeaf sliderInt
                  ( BaseUI.Slider.slider_defaultProps
                      { marks = unsafePartial (fromJust $ marks state.size)
                      , onChange = \{ start } -> action $ SetSize start
                      }
                  )
              , toBasic BaseUI.Card.styledAction
                  { children:
                    [ toBasic BaseUI.Button.button
                        { onClick: action Submit
                        , children:
                          [ R.text "OK"
                          ]
                        }
                    ]
                  }
              ]
            }
        ]
      }

sliderInt :: ReactClass (BaseUI.Slider.Slider_Props Int)
sliderInt = BaseUI.Slider.slider
