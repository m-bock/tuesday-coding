module Foo where

import Prelude
import Matrix (Matrix)
import Matrix.Extra (getRows) as Matrix
import Prim.Row (class Union, class Nub)
import React.Basic (JSX)
import React.Basic.DOM (Props_a, Props_div, Props_output, Props_table)
import React.Basic.DOM as DOM
import Record as Record
import Util (PatchStyle)

mk_ui_matrix ::
  { table :: PatchStyle
  , row :: PatchStyle
  , cell :: PatchStyle
  } ->
  { matrix :: Matrix JSX } ->
  JSX
mk_ui_matrix patch props =
  DOM.table
    $ patch.table
        { children:
          [ DOM.tbody { children: renderRow <$> Matrix.getRows props.matrix }
          ]
        }
  where
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
          { children: [ cell ] }
