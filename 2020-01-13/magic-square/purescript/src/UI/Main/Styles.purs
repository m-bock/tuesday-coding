module UI.Main.Styles where

import Prelude
import Debug.Trace (spy)
import Record as Record
import UI.Main.Markup.Types (Styles)
import Effect.Unsafe (unsafePerformEffect)

foreign import css :: Unit

styles :: Styles
styles =
  let
    scope = "UI__Main__"
  in
    { _root:
      ( \props ->
          Record.union props { className: scope <> "root" }
      )
    , item:
      ( \props ->
          Record.union props { className: scope <> "item" }
      )
    }
