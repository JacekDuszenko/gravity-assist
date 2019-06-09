module Constants where

import           Graphics.Gloss

-- | Constants related to UI and display
fps :: Int
fps = 200

bgColor :: Color
bgColor = makeColorI 1 5 255 0 -- ^ dark blue

shuttleColor :: Color
shuttleColor = green

moonColor :: Color 
moonColor = cyan

planetColor :: Color
planetColor = rose

screenWidth ::  Int
screenWidth = 1000

screenHeight :: Int
screenHeight = 800

screenPosX :: Int
screenPosX = 10 

screenPosY :: Int
screenPosY = 10 

windowTitle :: String
windowTitle = "Gravity assist" 

circleHeight :: Float
circleHeight = 80 

defaultWindowDisplay :: Display
defaultWindowDisplay = FullScreen

-- | Constants related moving of a planet, moon and shuttle parameters

-- | constant string identifiers for objects
shuttleObjectId = "SHUTTLE" :: String
moonObjectId = "MOON" :: String
planetObjectId = "PLANET" :: String

still :: Vector -- | Vector symbolizing an object with zero velocity
still = (0, 0)

sPlanetRadius :: Float
sPlanetRadius = sMoonRadius * 8

sPlanetPos :: Vector
sShuttlePos :: Vector
sMoonPos :: Vector
sMoonPos = (0,0)
sPlanetPos = (fst sMoonPos + 1.2 * sPlanetRadius, snd sMoonPos +  1.2 * sPlanetRadius)
sShuttlePos = (-screenXAsInt + 200, -halfOfScreenY)
    where
        halfOfScreenY = fromInteger $ toInteger $ screenHeight `div` 2
        screenXAsInt = fromInteger $ toInteger screenWidth

shuttleEngineThrustV :: Vector
shuttleEngineThrustV = (-200, 225) 

sShuttleV :: Vector
sShuttleV = shuttleEngineThrustV -- ^ Shuttle base speed in direction a bit to the left of the moon to demonstrate gravity assist

sShuttleA :: Vector
sShuttleA = still

sShuttleSize :: Float
sShuttleSize = 80

sShuttleMass :: Float
sShuttleMass = 100

sMoonV :: Vector -- ^ orbital velocity vector of the moon at the simulation start. (derived from the escape velocity formula)    
sMoonV = (300, -300)

sMoonA :: Vector
sMoonA = still

sMoonRadius :: Float
sMoonRadius = 100

sMoonMass :: Float
sMoonMass = sShuttleMass * 100000

sPlanetV :: Vector
sPlanetV = (0,-1) -- ^ Planet is orbiting around the Sun in the galaxy far, far away, so for our simulation we can neglect the impact of the sum         
                  -- ^ attractive force behave as if planet moved in the rectilinear motion for the case of simplicity.
sPlanetA :: Vector
sPlanetA = still -- ^ Acceleration also can be neglected because of aforementioned reasons.

sPlanetMass :: Float
sPlanetMass = 20 * sMoonMass

-- | Constants related to physics of the simulation
constG = 1 :: Float -- | for the sake of this experiment let's assume that constant G is equal to one -> it's an easy job to scale your parameters so that G is preserved
                    -- | The original value of G would be 6.67 * 10 ^^ (-11) m^3 / (kg * s^2)