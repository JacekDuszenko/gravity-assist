module SimState where
 -- ^  Simulation does not have physical units without a reason - I decided that user should be able to simulate
 -- ^  gravity assist effect on arbitrary three bodies, which ratio of masses and orbital speeds is known beforehand. Thus,
 -- ^  the user is able to simulate different scenarios by just changing the initial conditions

import           Graphics.Gloss.Data.Vector
import           Constants

data Simulation =
  Sim
    { shuttlePos   :: Vector -- ^ (x,y) position of space shuttle in 2D plane
    , shuttleV     :: Vector -- ^ (vx,vy) velocity vector of space shuttle in 2D plane
    , shuttleA     :: Vector -- ^ (ax,ay) acceleration vector of space shuttle in 2D plane
    , shuttleSize  :: Float -- ^ width of the square that represents shuttle
    , shuttleMass  :: Float -- ^ shuttle mass
    , moonPos      :: Vector -- ^ (x,y) position of the moon in 2D plane
    , moonV        :: Vector -- ^ (vx,vy) velocity vector of the moon in 2D plane
    , moonA        :: Vector -- ^ (ax,ay) acceleration vector of the moon in 2D plane
    , moonRadius   :: Float -- ^ radius of a moon
    , moonMass     :: Float -- ^ moon mass
    , planetPos    :: Vector -- ^ (x,y) position of the planet in 2D plane
    , planetV      :: Vector -- ^ (vx,vy) velocity vector of the planet in 2D plane
    , planetA      :: Vector -- ^ (ax,ay) acceleration vector of planet in 2D plane
    , planetRadius :: Float
    , planetMass   :: Float -- ^ planet mass
    }

instance Show Simulation where -- ^ Reformulation of `show` for debugging and game state tracking
  show sim = shuttle ++ br ++ moon ++ br ++ planet 
    where
      br = "\n"
      shuttle = (++) "shuttle position: " (show $ shuttlePos sim)
      moon = (++) "moon position: " (show $ moonPos sim)
      planet = (++) "planet position: " (show $ planetPos sim)

-- | This function creates init simulation state by generating Sim type with const values from Constants module
createInitState =  
  Sim
    { shuttlePos = sShuttlePos
    , shuttleV = sShuttleV
    , shuttleA = sShuttleA
    , shuttleSize = sShuttleSize
    , shuttleMass = sShuttleMass
    , moonPos = sMoonPos
    , moonV = sMoonV
    , moonA = sMoonA 
    , moonRadius = sMoonRadius
    , moonMass = sMoonMass
    , planetPos = sPlanetPos
    , planetV = sPlanetV
    , planetA = sPlanetA
    , planetMass = sPlanetMass
    , planetRadius = sPlanetRadius
}