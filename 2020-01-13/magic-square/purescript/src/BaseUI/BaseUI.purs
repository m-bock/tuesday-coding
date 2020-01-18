module BaseUI (ui_wrapper) where

import React (ReactClass)
import React as React

foreign import __esModule :: Boolean

foreign import ui_wrapper :: ReactClass { children :: React.Children }
