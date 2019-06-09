module Physics where

    import SimState
    import Constants
    import Graphics.Gloss
    import Graphics.Gloss.Data.Vector
    import Debug.Trace
    import Utils
    import Control.Arrow

    -- | Calculates distance between two points (vectors)
    d :: Point -> Point -> Float
    d (x1, y1) (x2, y2) = sqrt $ (x1 - x2) ^^ 2 + (y1 - y2) ^^ 2

    -- | Calculates attraction force value between two objects
    gForce :: Float -> Float -> Float -> Float -- ^ 1. Mass of first object, 2. Mass of second object, 3. Distance between objects 
    gForce m1 m2 r = (m1 * m2 * constG) / (r ^^ 2)

    -- | Adds two vectors
    add :: Vector -> Vector -> Vector
    add a = (+) (fst a) *** (+) (snd a) 

    -- | Calculates the vector that starts in point where vectorFrom points to and ends in point where vectorTo points to.
    vectorFromTo :: Vector -> Vector -> Vector
    vectorFromTo v1 v2 = let
      (x1, y1) = v1
      (x2, y2) = v2
      in (x2 - x1, y2 - y1)

    -- | Calculates the attraction force vector between two objects
    gForceVector :: Float -> Vector -> Vector -> Vector -- ^ 1. Attraction force value between objects, 2. position of the first object, 3. position of the second object
    gForceVector fval pos1 pos2 = mulSV fval $ normalizeV $ vectorFromTo pos1 pos2

     -- | Calculates the resultant vector from list of vectors
    resultantVector :: [Vector] -> Vector
    resultantVector = foldr add (0,0)

    -- | Computes attractional force between two objects specified by string id's (described in Utils module as string constants)
    -- | and returns value of attractional force vector between those two objects
    gForceBetweenObjects :: String -> String -> Simulation -> Float 
    gForceBetweenObjects id1 id2 sim = let
      props1 = unwrap sim id1
      props2 = unwrap sim id2
      distance = d (extrPos props1) (extrPos props2)
      in gForce (extrM props1) (extrM props2) distance

    -- | Calculates new position vector for an object
    computePos :: Float -> (Vector, Vector, Vector) -> Vector -- ^ 1. Position vector, 2. Velocity vector, 3. Acceleration vector
    computePos t ((x,y), (vx,vy), (ax,ay)) = (compPos x vx ax t, compPos y vy ay t) -- | Kinematic movement equations for position
      where compPos p v a t = p + v * t + 0.5 * a * (t ^^ 2)
    
      -- | Calculates new velocity vector for an object
    computeV :: Float -> (Vector, Vector, Vector) -> Vector
    computeV t (_, (vx,vy), (ax,ay)) = (vx + ax * t, vy + ay * t) -- | Kinematic movement equations for velocity  

    -- | Computes acceleration vector for a body on which attractive force is exerted and that body has mass
    computeA :: [Vector] -> Float -> Vector -- ^ 1. All forces vectors exerted on this body, 2. Body's invariant mass
    computeA forces mass = mulSV (let revMass = 1 / mass in revMass) (resultantVector forces) 

        -- ^ All forces that apply to the moon: 
        -- ^ 1. Attractive force of the shuttle. 
        -- ^ 2. Attractive force of the planet. 
    computeMoonA :: Simulation -> Vector
    computeMoonA sim = a
      where
        f1 = gForceVector (gForceBetweenObjects moonObjectId shuttleObjectId sim) (moonPos sim) (shuttlePos sim)
        f2 = gForceVector (gForceBetweenObjects moonObjectId planetObjectId sim) (moonPos sim) (planetPos sim)
        a = computeA [f1, f2] (moonMass sim)
        
    -- ^ All forces that apply to the shuttle: 
    -- ^ 1. Engine thrust which is reflected as constant base speed along certain vector, which is more precisely described in Constants module.
    -- ^ 2. Attractive force of the moon. 
    -- ^ 3. Attractive force of the planet. 
    computeShuttleA :: Simulation -> Vector
    computeShuttleA sim = a
      where
        f1 = gForceVector (gForceBetweenObjects shuttleObjectId moonObjectId sim) (shuttlePos sim) (moonPos sim)
        f2 = gForceVector (gForceBetweenObjects shuttleObjectId planetObjectId sim) (shuttlePos sim) (planetPos sim)
        a = computeA [f1, f2] (shuttleMass sim) 

    -- | We assume that forces exerted by other bodies on the planet are neglected for simplicity of this simulation.
    -- | Furthermore, we assume that Sun in the galaxy far, far away exists and exerts attractive force on the planet, which
     -- | is simulated with a constant speed that this planet has. Acceleration of this force is yet again neglected.
    updatePlanetPhysics :: Float -> Simulation -> (Vector, Vector, Vector)
    updatePlanetPhysics t sim = let
      (pos, v, a) = (planetPos sim, planetV sim, planetA sim)
      newV = computeV t (pos, v, a)
      newPos = computePos t (pos, newV, a)
      in
      (newPos, newV, a)
        
    updateMoonPhysics :: Float -> Simulation -> (Vector, Vector, Vector)
    updateMoonPhysics t sim = let
      (pos, v, a) = (moonPos sim, moonV sim, moonA sim)
      newA = computeMoonA sim
      newV = computeV t (pos, v, newA)
      newPos = computePos t (pos, newV, newA)
      in
      (newPos, newV, newA)
            
    updateShuttlePhysics :: Float -> Simulation -> (Vector, Vector, Vector)
    updateShuttlePhysics t sim = let
      (pos,v,a) = (shuttlePos sim, shuttleV sim, shuttleA sim)
      newA = computeShuttleA sim
      newV = computeV t (pos, v, newA)
      newPos = computePos t (pos, newV, newA)
      in
      (newPos, newV, newA)