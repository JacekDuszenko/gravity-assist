module Rendering where

import SimState
import Graphics.Gloss.Data.Picture
import Constants

-- | Utility function that accepts tuple instead of two float args to translate picture for given coordinates
translate' :: Vector -> Picture -> Picture 
translate' = uncurry translate

-- | Function that serves as an abstract footprint for all objects thare are to be rendered on the screen. It takes a couple of builder functions
-- | and outputs a fully prepared and ready to be drew Picture object
renderGeneric  :: Simulation -- ^ simulation that contains objects to be displayed
    -> (Picture -> Picture) -- ^ function that colors a shape by a given hardcoded color
    -> (Float -> Picture) -- ^ function that takes size of a shape and draws the shape given by contained inside gloss lib function
    -> (Simulation -> Float) -- ^ function that accesses predefined size out of simulation object
    -> (Simulation -> Vector) -- ^ function that accesses predefined object vector out of simulation object
    -> Picture -- ^ this function returns fully fledged, ready to be printed, picture
renderGeneric sim colF drawShapeF sizeAccF posAccF = 
    translate' pos $ (colF . drawShapeF) size
        where
            size = sizeAccF sim
            pos = posAccF sim

-- | builder functions for a shuttle
colorShuttle :: Picture -> Picture
colorShuttle = color shuttleColor
drawSquare :: Float -> Picture
drawSquare size = rectangleSolid size size
renderShuttle :: Simulation -> Picture
renderShuttle sim =  renderGeneric sim colorShuttle drawSquare shuttleSize shuttlePos

-- | builder functions for a moon
colorMoon :: Picture -> Picture
colorMoon = color moonColor
renderMoon :: Simulation -> Picture
renderMoon sim = renderGeneric sim colorMoon circleSolid moonRadius moonPos

-- | builder functions for a planet
colorPlanet :: Picture -> Picture
colorPlanet = color planetColor
renderPlanet :: Simulation -> Picture
renderPlanet sim = renderGeneric sim colorPlanet circleSolid planetRadius planetPos

render :: Simulation -> Picture
render sim = pictures $ map (\f -> f sim) [renderShuttle, renderMoon, renderPlanet] 


