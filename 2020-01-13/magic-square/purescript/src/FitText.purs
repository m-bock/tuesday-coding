module FitText where

import React (ReactClass)
import React as React

foreign import fitText ::
  ReactClass
    { children :: React.Children
    , compressor :: Number
    }
