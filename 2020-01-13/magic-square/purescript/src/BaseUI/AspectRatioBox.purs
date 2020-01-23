module BaseUI.AspectRatioBox where

import Prelude
import React (ReactClass)
import React as React
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Effect (Effect)

-- AspectRatioBox
--
foreign import aspectRatioBox ::
  ReactClass
    { children :: React.Children
    , width :: String
    }

-- AspectRatioBoxBody
--
foreign import aspectRatioBoxBody ::
  ReactClass
    { children :: React.Children }
