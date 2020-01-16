module Main where

import Prelude
import Control.Monad.Gen (chooseInt)
import Data.Array as Array
import Data.Either (Either(..), either)
import Data.Foldable (for_, traverse_)
import Data.Lens (foldOf)
import Data.Map (Map)
import Data.Map as Map
import Data.Newtype (class Newtype, over, over2, unwrap, wrap)
import Data.Ord (abs)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import Data.Typelevel.Num (class Add, class AddP, class DivMod, class LtEq, class Nat, D0, D1, D2, D3, reifyInt, toInt, toInt')
import Data.Vec (Vec, vec2)
import Data.WrapNatural (WrapNatural)
import Effect (Effect)
import Effect.Console (log)
import Partial.Unsafe (unsafeCrashWith)
import Refine (class Validate, And, Not, Refined, refine, unrefine, unsafeRefine)
import Refine as Refine
import Test.QuickCheck (class Arbitrary, Result, arbitrary, quickCheck, quickCheck', withHelp, (<=?), (===), (>=?))
import Test.QuickCheck.Gen (randomSample)
import Test.QuickCheck.Laws.Data (checkBounded, checkCommutativeRing, checkEuclideanRing, checkRing, checkSemiring)
import Type.Proxy (Proxy(..))

data IsNatural

data IsEven

type IsOdd
  = Not IsEven

instance validateEven :: Validate IsEven Int where
  validate _ x
    | x `mod` 2 == 0 = pure unit
  validate _ _ = Left "Even error"

instance validateIsNatural :: Validate IsNatural Int where
  validate _ x
    | x >= 0 = pure unit
  validate _ _ = Left "Pos error"

-- Grid
--
type Grid w h a
  = { size :: Vec D2 Int
    , data_ :: Map { x :: Int, y :: Int } a
    }

grid_init :: forall a w h. Nat w => Nat h => a -> Grid w h a
grid_init val =
  let
    width = toInt' (Proxy :: Proxy w)

    height = toInt' (Proxy :: Proxy h)

    size = vec2 width height

    data_ =
      Map.fromFoldable do
        x <- Array.range 0 width # Array.dropEnd 1
        y <- Array.range 0 height # Array.dropEnd 1
        pure $ Tuple { x, y } val
  in
    { data_, size
    }

--
solve :: forall n. Nat n => DivMod n D2 _ D1 => n -> Grid n n Int
solve = unsafeCrashWith ""

main :: Effect Unit
main = do
  check' (-1)
  check' 2
  check' 3
  where
  check' x = log $ either (const "error") (const "ok") ((refine x) :: _ _ (_ (And IsNatural IsOdd) _))
