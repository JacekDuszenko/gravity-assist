module Main where

import           Constants
import           SimState
import           Rendering
import           UpdateState
import           Graphics.Gloss
import           Graphics.Gloss.Data.ViewPort

-- | initial state of the simulation. User can compare different sizes of planets/moons (basically
-- | any bodies), their speeds and replace those values with example ones that are provided.
initialState :: Simulation
initialState = createInitState

main :: IO ()
main = simulate defaultWindowDisplay bgColor fps initialState render updateState