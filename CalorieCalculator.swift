//
//  CalorieCalculator.swift
//  Actibetes
//
//  Created by Sarah-Jessica Jemitola on 11/03/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import Foundation
class CalorieCalculator {
    static let calculator = CalorieCalculator()
    
    func calculateCaloriesBurned(metValue:Double, bodyWeight: Double, activityDurationInMinutes: Double) -> Double{
        let caloriesBurnedPerMinute = (metValue*3.5*bodyWeight)/200
        let totalCaloriesBurned = caloriesBurnedPerMinute*activityDurationInMinutes
        return totalCaloriesBurned //measured in kcal per min
    }
}