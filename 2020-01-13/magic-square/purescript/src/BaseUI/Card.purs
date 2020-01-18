module BaseUI.Card where

import React (ReactClass)
import React as React

-- Card
--
foreign import card :: ReactClass Card_Props

type Card_Props
  = { children :: React.Children
    , title :: String
    }

-- StyledBody
--
foreign import styledBody :: ReactClass StyledBody_Props

type StyledBody_Props
  = { children :: React.Children
    }

-- StyledAction
--
foreign import styledAction :: ReactClass StyledAction_Props

type StyledAction_Props
  = { children :: React.Children
    }
