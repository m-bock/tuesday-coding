module UI.Main.Control.Types where

import Data.Maybe (Maybe)
import Data.Array.NonEmpty (NonEmptyArray)
import Matrix (Matrix)

type Props
  = { 
    }

type State
  = { builders :: Maybe (NonEmptyArray (Matrix (Maybe Int)))
    }

data Action
  = SetBuilders (NonEmptyArray (Matrix (Maybe Int)))
