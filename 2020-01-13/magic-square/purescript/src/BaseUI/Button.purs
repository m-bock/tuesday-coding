module BaseUI.Button where

import Prelude
import React (ReactClass)
import React as React
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Effect (Effect)

-- Button
--
type Button_Props
  = { children :: React.Children
    , onClick :: Effect Unit
    }

button :: ReactClass Button_Props
button =
  React.statelessComponent \props ->
    React.createLeafElement button_impl
      { children: props.children
      , onClick: mkEffectFn1 \_ -> props.onClick
      }

foreign import button_impl ::
  ReactClass
    { children :: React.Children
    , onClick :: EffectFn1 Unit Unit
    }
