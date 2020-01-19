module UI.Main (ui) where

import Prelude
import React.Basic (JSX)
import UI.Main.Control as Control
import UI.Main.Markup as Markup
import UI.Main.Styles as Styles
import UI.Main.Control.Types as Control.Types

ui :: Control.Types.Props -> JSX
ui =
  Styles.styles
    # Markup.mkRender
    # Control.mkUI
