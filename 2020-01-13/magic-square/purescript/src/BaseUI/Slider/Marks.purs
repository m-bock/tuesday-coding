module BaseUI.Slider.Marks (Marks, create, default, toSpec) where

import Prelude
import Data.Foldable (all)
import Data.Maybe (Maybe(..), fromJust)
import Partial.Unsafe (unsafePartial)

newtype Marks a
  = Marks (Marks_Spec a)

type Marks_Spec a
  = { max :: a
    , start :: a
    , end :: Maybe a
    , min :: a
    , step :: a
    }

create ::
  forall a.
  Ord a =>
  Semiring a =>
  EuclideanRing a =>
  Marks_Spec a -> Maybe (Marks a)
create spec@{ max, min, start, end, step } =
  if all identity
    [ step > zero
    , (start - min) `mod` step == zero
    , (max - min) `mod` step == zero
    , min <= start
    , start <= max
    , case end of
        Just end' ->
          all identity
            [ min <= end'
            , end' <= end'
            , (end' - min) `mod` step == zero
            ]
        Nothing -> true
    ] then
    Just (Marks spec)
  else
    Nothing

default :: Marks Int
default =
  unsafePartial
    ( fromJust
        $ create
            { min: 0
            , start: 0
            , end: Nothing
            , max: 100
            , step: 1
            }
    )

toSpec :: forall a. Marks a -> Marks_Spec a
toSpec (Marks spec) = spec
