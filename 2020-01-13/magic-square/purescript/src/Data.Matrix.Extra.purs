module Data.Matrix.Extra where

import Prelude
import Data.Array as Array
import Data.Matrix (Matrix(..))
import Data.Matrix as Matrix
import Data.Maybe (fromJust)
import Data.Typelevel.Num (class Lt, class Nat, class Succ, class Trich, D0, D2, LT, d0, d1, reifyInt, toInt')
import Data.Vec (Vec)
import Data.Vec as Vec
import Data.WrapInt (WrapInt)
import Data.WrapInt as WrapInt
import Partial.Unsafe (unsafeCrashWith, unsafePartial)

lookup ::
  forall max s a.
  Succ max s =>
  Vec D2 (WrapInt D0 max) -> Matrix s s a -> a
lookup pos' mat =
  let
    pos = map WrapInt.toInt pos'
  in
    unsafePartial
      $ Matrix.unsafeIndex mat (pos Vec.!! d0) (pos Vec.!! d1)

set ::
  forall max s a.
  Succ max s =>
  Vec D2 (WrapInt D0 max) -> a -> Matrix s s a -> Matrix s s a
set pos x (Matrix mat) =
  Matrix
    $ updateAt' (pos Vec.!! d1)
        ( \(row :: Vec s a) ->
            updateAt' (pos Vec.!! d0) (\_ -> x) row
        )
        mat
  where
  updateAt' :: forall b. WrapInt D0 max -> (b -> b) -> Vec s b -> Vec s b
  updateAt' i f vec =
    unsafePartial
      ( vec
          # Vec.toArray
          # Array.modifyAt (WrapInt.toInt i) f
          >>= Vec.fromArray
          # fromJust
      )
