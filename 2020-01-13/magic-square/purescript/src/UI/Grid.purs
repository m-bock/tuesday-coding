module UI.Grid (ui, UI, Props) where

import Prelude
import Data.Maybe (Maybe, maybe)
import Matrix (Matrix)
import Matrix.Extra (getRows) as Matrix
import Prim.Row (class Union)
import React.Basic (JSX)
import React.Basic.DOM (CSS, Props_table)
import React.Basic.DOM as DOM
import Record as Record
import Style.Debug (debugStyle)
import Unsafe.Coerce (unsafeCoerce)
import Util (PatchStyle, Style, Patch, patchStyle, style_toProps)

type UI
  = Props -> JSX

type Props
  = { matrix :: Matrix (Maybe Int) }

ui :: UI
ui = mk_ui { patch }

-- Markup.Types
--
type Options
  = { patch :: Patches }

type Patches
  = { table :: PatchStyle
    , row :: PatchStyle
    , cell :: PatchStyle
    , card :: PatchStyle
    }

-- Markup 
--
mk_ui :: Options -> UI
mk_ui { patch } props = renderTable
  where
  renderTable =
    DOM.table
      $ patch.table
          { children:
            [ DOM.tbody
                { children: renderRow <$> Matrix.getRows props.matrix
                }
            ]
          }

  renderRow row =
    DOM.tr
      $ patch.row
          { children:
            row
              <#> renderCell
          }

  renderCell cell =
    DOM.td
      $ patch.cell
          { children: maybe [] (pure <<< renderCard) cell }

  renderCard (n :: Int) =
    DOM.div
      $ patch.card
          { children:
            [ DOM.text $ show n
            ]
          }

-- Styles
-- 
patch :: Patches
patch =
  { table: foo
  , row: foo
  , cell: foo
  , card: foo
  }

foo ::
  forall r1 r2.
  Union
    r1
    ( className :: String
    , style :: CSS
    )
    r2 =>
  { | r1 } -> { | r2 }
foo props = Record.union props (style_toProps debugStyle)
