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
import AFDateHelper
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
        
        let formData = self.form.formValues()
        let actibetesData = buildActibetesData(formData as! [String:AnyObject])
        let actibetesEntry = ActibetesEntry(dict: actibetesData)
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
        

        actibetesEntryForm.sections = [section1, section3]
        self.form = actibetesEntryForm
    }
    
    private func buildActibetesData(var data: [String:AnyObject]) -> [String:AnyObject]{
                if let bloodGlucoseLevel = (data["bloodGlucoseLevel"] as? NSString)?.doubleValue{
                    //set glucose measurement
                    data.updateValue(bloodGlucoseLevel, forKey: "bloodGlucoseLevel")
                }else{
                    data.updateValue(-1, forKey: "bloodGlucoseLevel")
                }
                if let carbs = (data["carbs"] as? NSString)?.integerValue{
                    //set carbs
                    data.updateValue(carbs, forKey: "carbs")
                }else{
                    data.updateValue(-1, forKey: "carbs")
                }

                if let mealDateAndTime = data["mealTime"] as? NSDate{
                    //set date and time
                    let mealDate: String = mealDateAndTime.toString(format: .ISO8601(ISO8601Format.Date))
                    let mealHour: String = String(mealDateAndTime.hour())
                    let intMinute: Int = mealDateAndTime.minute()
                    var mealMinute: String
                    if intMinute < 10{
                        let minuteString: String = String(intMinute)
                        mealMinute = "0"+minuteString
                    }else{
                        mealMinute = String(intMinute)
                    }
                    
                    let mealTime: String = "\(mealHour):\(mealMinute)"

                    data["mealDate"] = mealDate
                    data.updateValue(mealTime, forKey: "mealTime")
                }else{
                    data.updateValue("no date and time", forKey: "mealTime")
                }


        return data
    }
    
    func sendJSONData(data:[String:AnyObject]?){
        Alamofire.request(.POST, url, parameters:data, encoding: .JSON).responseJSON(completionHandler: { response in
            print(response)
        })
    }
}
