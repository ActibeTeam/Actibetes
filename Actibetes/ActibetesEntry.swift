//
//  PedagochiEntry.swift
//  Pedagochi
//
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class ActibetesEntry {
    var bloodGlucoseLevel: Float!
    //var time
    //var location
    var carbs: Int!
    //var insulinUnits: Insulin?
    var mealDescription: String!
    
    func toAnyObject() -> AnyObject {
        return [
            "bloodGlucoseLevel": bloodGlucoseLevel,
            "carbs": carbs,
            "mealDescription": mealDescription
        ]
    }
    
}