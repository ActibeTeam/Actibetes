//
//  ActibetesEntry.swift
//  Actibetes
//
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import Firebase
class ActibetesEntry {
    var bloodGlucoseLevel: Double?
    var mealTime: String?
    var additionalNotes: String?
    var insulinType: String?
    var insulinUnits: Int?
    var carbs: Int?
    
    init(dict: [String:AnyObject]){
        if let bg = (dict["bloodGlucoseLevel"] as? NSString)?.doubleValue{
            bloodGlucoseLevel = bg
        }else{
            bloodGlucoseLevel = -1
        }
        if let cb = (dict["carbs"] as? NSString)?.integerValue{
            carbs = cb
        }else{
            carbs = -1
        }
//        if let ins = dict["insulinUnits"] as? Int{
//            insulinUnits = ins
//        }else{
//            insulinUnits = -1
//        }
        if let dateAndTime = dict["mealTime"] as? NSDate{
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            mealTime = dateFormatter.stringFromDate(dateAndTime)
        }else{
            mealTime = "null"
        }
        
        //mealTime = dict["mealTime"] as? String
        //additionalNotes = dict["additionalNotes"] as? String
        //insulinType = dict["insulinType"] as? String


    }
    
    func toFirebaseCompliantObject() -> [String:AnyObject] {
        return [
            "bloodGlucoseLevel": bloodGlucoseLevel!,
            "mealTime": mealTime!,
            "carbs": carbs!,
            "timeAddedToDatabase": FirebaseServerValue.timestamp()
            //"insulinType": insulinType!,
            //"insulinUnits": insulinUnits!,
            //"additionalNotes": additionalNotes!
        ]
    }
    
}