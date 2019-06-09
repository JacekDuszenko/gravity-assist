module Utils where
    import SimState
    import Constants
    import Graphics.Gloss
    -- | Utility function that takes a simulation object and identifier of one of objects: "PLANET", "SHUTTLE", "MOON" and returns
    -- | all meaningful from the physical point of view informations in a tuple, subsequently: position vector, velocity vector, acceleration vector, mass
    unwrap :: Simulation -> String -> (Vector, Vector, Vector, Float)
    unwrap sim objectId 
        | objectId == shuttleObjectId = (shuttlePos sim, shuttleV sim , shuttleA sim , shuttleMass sim)
        | objectId == moonObjectId = (moonPos sim , moonV sim, moonA sim, moonMass sim)
        | objectId == planetObjectId = (planetPos sim, planetV sim , planetA sim, planetMass sim)
        | otherwise = (still, still, still, 0)

    -- | below methods extract particular physical proerties from props described in aforementioned method 
    extrPos :: (Vector, Vector, Vector, Float) -> Vector
    extrPos (p, _, _, _) = p

    extrV :: (Vector, Vector, Vector, Float) -> Vector
    extrV (_, v, _, _) = v

    extrA :: (Vector, Vector, Vector, Float) -> Vector
    extrA (_, _, a, _) = a

    extrM :: (Vector, Vector, Vector, Float) -> Float
    extrM (_, _, _, m) = m