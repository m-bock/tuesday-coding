module BaseUI.Slider
  ( slider
  , slider_defaultProps
  , class NumberLike
  , toNumber
  , fromNumber
  , Slider_Props
  ) where

import Prelude
import BaseUI.Slider.Marks (Marks)
import BaseUI.Slider.Marks as Marks
import Data.Array as Array
import Data.Int as Int
import Data.Maybe (Maybe, maybe)
import Effect (Effect)
import Effect.Class.Console (log)
import Partial.Unsafe (unsafePartial)
import React (ReactClass)
import React as React
import Data.Function.Uncurried (mkFn1, Fn1, mkFn2, Fn2)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Data.Maybe (Maybe(Nothing))

-- Slider
--
type Slider_Props a
  = { marks :: Marks a
    , onChange ::
      { start :: a
      , end :: Maybe a
      } ->
      Effect Unit
    , onFinalChange ::
      { start :: a
      , end :: Maybe a
      } ->
      Effect Unit
    }

slider :: forall a. NumberLike a => ReactClass (Slider_Props a)
slider =
  React.statelessComponent \props ->
    let
      { start, end, min, max, step } = Marks.toSpec props.marks

      onChange =
        mkEffectFn1 \{ value } -> do
          props.onChange
            { start: fromNumber (unsafePartial (value `Array.unsafeIndex` 0))
            , end: fromNumber <$> (value `Array.index` 1)
            }
    in
      React.createLeafElement slider_impl
        { value: [ toNumber start ] <> maybe [] pure (toNumber <$> end)
        , max: toNumber max
        , min: toNumber min
        , onChange
        , onFinalChange: onChange
        , step: toNumber step
        }

slider_defaultProps :: Slider_Props Int
slider_defaultProps =
  { marks: Marks.default
  , onChange: const $ pure unit
  , onFinalChange: const $ pure unit
  }

foreign import slider_impl ::
  ReactClass
    { value :: Array Number
    , max :: Number
    , min :: Number
    , onChange :: EffectFn1 { value :: Array Number } Unit
    , onFinalChange :: EffectFn1 { value :: Array Number } Unit
    , step :: Number
    }

-- NumberLike
--
class NumberLike a where
  toNumber :: a -> Number
  fromNumber :: Number -> a

instance numberLike_Int :: NumberLike Int where
  toNumber = Int.toNumber
  fromNumber = Int.round
