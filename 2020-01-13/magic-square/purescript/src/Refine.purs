module Refine
  ( And
  , Or
  , Not
  , RefineError
  , Refined
  , refine
  , class Validate
  , validate
  , unrefine
  , unsafeRefine
  , unsafeOver2
  ) where

import Prelude
import Control.Alt ((<|>))
import Data.Bifunctor (bimap)
import Data.Either (Either(..))
import Type.Proxy (Proxy(..))

data And p1 p2

data Or p1 p2

data Not p

class Validate p a where
  validate :: Proxy p -> a -> Either String Unit

instance validateAnd :: (Validate p1 a, Validate p2 a) => Validate (And p1 p2) a where
  validate _ x =
    validate (Proxy :: Proxy p1) x
      <* validate (Proxy :: Proxy p1) x

instance validateOr :: (Validate p1 a, Validate p2 a) => Validate (Or p1 p2) a where
  validate _ x =
    validate (Proxy :: Proxy p1) x
      <|> validate (Proxy :: Proxy p1) x

instance validateNot :: (Validate p a) => Validate (Not p) a where
  validate _ x = case validate (Proxy :: Proxy p) x of
    Left _ -> Right unit
    Right unit -> Left "Not error"

data RefineError a
  = RefineError a String

newtype Refined t a
  = Refined a

refine :: forall p a. (Validate p a) => a -> Either (RefineError a) (Refined p a)
refine x =
  validate (Proxy :: Proxy p) x
    # bimap (RefineError x) (const $ Refined x)

unrefine :: forall t a. Refined t a -> a
unrefine (Refined x) = x

unsafeRefine :: forall a p. a -> Refined p a
unsafeRefine x = Refined x

unsafeOver2 :: forall p a b c. (a -> b -> c) -> Refined p a -> Refined p b -> Refined p c
unsafeOver2 f x1 x2 = unsafeRefine $ f (unrefine x1) (unrefine x2)
