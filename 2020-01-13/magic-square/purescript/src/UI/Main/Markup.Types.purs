module UI.Main.Markup.Types where

import Util (Patch)

type Styles
  = ( { _root :: Patch ( className :: String )
      , item :: Patch ( className :: String )
      }
    )
