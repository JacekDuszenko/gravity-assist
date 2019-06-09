module UpdateState where

    import Graphics.Gloss.Data.ViewPort
    import SimState
    import Constants
    import Physics
    import Utils
    
    updateGeneric movementEquationsF objectId t sim
        | objectId == shuttleObjectId = sim { shuttlePos = newPos, shuttleV = newV, shuttleA = newA }
        | objectId == moonObjectId = sim { moonPos = newPos, moonV = newV, moonA = newA }
        | objectId == planetObjectId = sim {planetPos = newPos, planetV = newV, planetA = newA }
        | otherwise = sim
        where
            (newPos, newV, newA) = movementEquationsF t sim

    -- | Functions that update objects position. In this simulation the planet circulates around invisible Sun, which is
    -- | simulated with a circular motion around a point in the galaxy far, far away :)
    updatePlanet :: Float -> Simulation -> Simulation
    updatePlanet = updateGeneric updatePlanetPhysics planetObjectId
    
    updateMoon :: Float -> Simulation -> Simulation
    updateMoon = updateGeneric updateMoonPhysics moonObjectId

    updateShuttle :: Float -> Simulation -> Simulation
    updateShuttle = updateGeneric updateShuttlePhysics shuttleObjectId
            
    updateState :: ViewPort -> Float -> Simulation -> Simulation
    updateState _ t = updatePlanet' . updateMoon' . updateShuttle'
            where
                updateShuttle' = updateShuttle t
                updateMoon' = updateMoon t
                updatePlanet' = updatePlanet t