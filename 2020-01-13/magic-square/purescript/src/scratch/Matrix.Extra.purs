module Matrix.Extra (getRows) where

import Prelude
import Data.Array as Array
import Data.Maybe as Maybe
import Matrix (Matrix)
import Matrix as Matrix
import Partial.Unsafe (unsafePartial)

getRows :: forall a. Matrix a -> Array (Array a)
getRows mat =
  Array.range 0 (Matrix.height mat - 1)
    <#> (\index -> unsafePartial (Maybe.fromJust $ Matrix.getRow index mat))
