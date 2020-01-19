module Style.Debug where

import Prelude
import React.Basic.DOM (CSS, css)
import Util (Style)

debugStyle :: Style
debugStyle =
  { classNames: []
  , css:
    css
      { outline: "1px solid black" }
  }
