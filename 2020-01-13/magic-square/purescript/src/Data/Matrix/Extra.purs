module Data.Matrix.Extra where

import Prelude
import Data.Array (foldr)
import Data.Array as Array
import Data.Matrix (Matrix(..))
import Data.Matrix as Matrix
import Data.Maybe (fromJust)
import Data.String as String
import Data.String.Utils (padStart) as String
import Data.Typelevel.Num (class Lt, class Nat, class Pos, class Succ, class Trich, D0, D2, LT, d0, d1, reifyInt, toInt, toInt')
import Data.Typelevel.Undefined (undefined)
import Data.Vec (Vec)
import Data.Vec as Vec
import Data.WrapNatural (WrapNatural)
import Data.WrapNatural as WrapNatural
import Partial.Unsafe (unsafeCrashWith, unsafePartial)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Matrix as MatrixUntyped

lookup ::
  forall s a.
  Pos s =>
  Vec D2 (WrapNatural D0 s) -> Matrix s s a -> a
lookup pos' mat =
  let
    pos = map WrapNatural.toInt pos'
  in
    unsafePartial
      $ Matrix.unsafeIndex mat (pos Vec.!! d0) (pos Vec.!! d1)

set ::
  forall s a.
  Pos s =>
  Vec D2 (WrapNatural D0 s) -> a -> Matrix s s a -> Matrix s s a
set pos x (Matrix mat) =
  Matrix
    $ updateAt' (pos Vec.!! d1)
        ( \(row :: Vec s a) ->
            updateAt' (pos Vec.!! d0) (\_ -> x) row
        )
        mat
  where
  updateAt' :: forall b. WrapNatural D0 s -> (b -> b) -> Vec s b -> Vec s b
  updateAt' i f vec =
    unsafePartial
      ( vec
          # Vec.toArray
          # Array.modifyAt (WrapNatural.toInt i) f
          >>= Vec.fromArray
          # fromJust
      )

diagonal_main :: forall s a. Nat s => Matrix s s a -> Vec s a
diagonal_main mat =
  Vec.range 0 (undefined :: s)
    <#> (\i -> unsafePartial $ Matrix.unsafeIndex mat i i)

diagonal_counter :: forall s a. Nat s => Matrix s s a -> Vec s a
diagonal_counter mat =
  let
    max = toInt' (Proxy :: Proxy s) - 1
  in
    Vec.range 0 (undefined :: s)
      <#> (\i -> unsafePartial $ Matrix.unsafeIndex mat i (max - i))

rows :: forall w h a. Matrix h w a -> Vec h (Vec w a)
rows (Matrix rows') = rows'

columns :: forall w h a. Nat h => Nat w => Matrix h w a -> Vec w (Vec h a)
columns mat@(Matrix rows') =
  Vec.range 0 (undefined :: w)
    <#> ( \x ->
          Vec.range 0 (undefined :: h)
            <#> ( \y ->
                  unsafePartial
                    $ Matrix.unsafeIndex mat x y
              )
      )

prettyPrint :: forall h w a. Nat h => Nat w => Show a => Matrix h w a -> String
prettyPrint mat =
  let
    mat' = map show mat

    maxLength = foldr (\x m -> String.length x `max` m) 0 mat'
  in
    Array.range 0 (toInt (undefined :: h) - 1)
      <#> ( \y ->
            Array.range 0 (toInt (undefined :: w) - 1)
              <#> ( \x ->
                    unsafePartial
                      $ ( Matrix.unsafeIndex mat' x y
                            # String.padStart maxLength
                        )
                )
              # String.joinWith " "
        )
      # String.joinWith "\n"

toUntyped :: forall h w a. Nat h => Nat w => Matrix h w a -> MatrixUntyped.Matrix a
toUntyped mat =
  unsafePartial
    ( Matrix.toArray mat
        # MatrixUntyped.fromArray
        # fromJust
    )
