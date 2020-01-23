module Style where

import Data.String as String
import React.Basic.DOM (CSS)
import Record as Record

type Style
  = { css :: CSS
    , classNames :: Array String
    }

style_toProps :: Style -> { style :: CSS, className :: String }
style_toProps style =
  { style: style.css
  , className: String.joinWith " " style.classNames
  }

patchStyle :: forall r. Style -> { | r } -> { style :: CSS, className :: String | r }
patchStyle style r =
  Record.union
    { style: style.css
    , className: String.joinWith " " style.classNames
    }
    r
