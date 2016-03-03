//
//  ActibetesTableViewController.swift
//  Actibetes
//
//  Created by Lanre Durosinmi-Etti on 22/02/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import UIKit
import Firebase
import SwiftForms
import Alamofire
class ActibetesTableViewController: FormViewController {
    
    var actibetesRootReference: Firebase?
    let url = "http://192.168.0.9:8080/HammerServer/webapi/user"
    var actibetesEntry:ActibetesEntry?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //form setup
        self.setupUserForm()
        //set up firebase URL
        let path = NSBundle.mainBundle().pathForResource("FirebaseProperties", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let firebaseRootUrl = dict?.valueForKey("firebaseRootUrl") as! String
        actibetesRootReference  = Firebase(url: firebaseRootUrl)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        //setup 'accept'button on right hand side of nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Accept", style: UIBarButtonItemStyle.Plain, target: self, action: "submitInfo")
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitInfo() {
        
        let actibetesData = self.form.formValues()
        let actibetesEntry = ActibetesEntry(dict: actibetesData as! [String : AnyObject])
        //let data = actibetesData as! [String : AnyObject]
       // let glucoselevel = data["bloodGlucoseLevel"] as! Float
       // print(actibetesData.description)
        //let jsonData = buildActibetesData(actibetesData as! [String:AnyObject])
        let uid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let actibetesDataTransformed = actibetesEntry.toFirebaseCompliantObject()
        FirebaseDataService.dataService.addNewActibetesEntry(actibetesDataTransformed, uid: uid)
  
    }
    
    
    private func setupUserForm(){
        let actibetesEntryForm = FormDescriptor()
        let section1 = FormSectionDescriptor()
        section1.headerTitle = "Blood Glucose Information"
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: "bloodGlucoseLevel", rowType: .Decimal, title: "Blood Glucose")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "mmol/L", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
//        let section2 = FormSectionDescriptor()
//        section2.headerTitle = "Activity Information"
//        row = FormRowDescriptor(tag: "activityDuration", rowType: .Number, title: "Duration of Activity")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "minutes", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
//        section2.addRow(row)
        
        let section3 = FormSectionDescriptor()
        section3.headerTitle = "Meal Information"
        row = FormRowDescriptor(tag: "carbs", rowType: .Number, title: "Carbs")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "g", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        
        section3.addRow(row)
        row = FormRowDescriptor(tag: "mealTime", rowType: .Time, title: "Time of Meal")
        row.value = NSDate()
        section3.addRow(row)
        
        
//        
//        let section5 = FormSectionDescriptor()
//        section5.headerTitle = "Picker"
//        row = FormRowDescriptor(tag: "picker", rowType: .Picker, title: "Gender")
//        row.configuration[FormRowDescriptor.Configuration.Options] = ["F", "M", "U"]
//        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
//            switch( value ) {
//            case "F":
//                return "Female"
//            case "M":
//                return "Male"
//            case "U":
//                return "I'd rather not to say"
//            default:
//                return nil
//            }
//            } as TitleFormatterClosure
//        
//        row.value = "M"
//        
//        section5.addRow(row)
        
        
        
        
        actibetesEntryForm.sections = [section1, section3]
        self.form = actibetesEntryForm
    }
    
    private func buildActibetesData(var data: [String:AnyObject]) -> [String:AnyObject]{
        //set carbs
        data.updateValue((data["Meal_"] as! NSString).doubleValue, forKey: "Meal_")
        //set meal time
        let mealDateandTime = data["mealTime_"] as! NSDate
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        var dateAndTimeString:String = dateFormatter.stringFromDate(mealDateandTime)
        data.updateValue(dateAndTimeString, forKey: "mealTime_")
        //set glucose measurement
        data.updateValue((data["lastGLM_"] as! NSString).doubleValue, forKey: "lastGLM_")


        //set current time
        let todaysDate:NSDate = NSDate()
         dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
         dateAndTimeString = dateFormatter.stringFromDate(todaysDate)
        data["timeString_"] = dateAndTimeString
        return data
    }
    
    func sendJSONData(data:[String:AnyObject]?){
        Alamofire.request(.POST, url, parameters:data, encoding: .JSON).responseJSON(completionHandler: { response in
            print(response)
        })
    }
}
