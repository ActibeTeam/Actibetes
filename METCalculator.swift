//
//  METCalculator.swift
//  Actibetes
//
//  Created by Sarah-Jessica Jemitola on 11/03/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import Foundation
class METCalculator{
    static let calculator = METCalculator()
    private let gradient: Double = 1.6094
    private let yIntercept: Double = 0.3157
    private let oneMetrePerSecToMPH: Double = 2.23694
    
    func convertRunningSpeedToMET(speed:CGFloat) -> Double{
        var newSpeedDouble = Double(speed)  //create double from CGFloat
        newSpeedDouble = convertMetresPerSecondToMilesPerHour(newSpeedDouble)
        var metResult: Double
        
        metResult = newSpeedDouble*gradient + yIntercept
        
        return metResult
        
        
    }
    
    private func convertMetresPerSecondToMilesPerHour(speed:Double) -> Double{
        let speedInMPH = speed*oneMetrePerSecToMPH
        return speedInMPH
    }
}