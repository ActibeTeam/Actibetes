//
//  ActibetesEntryController.swift
//  Actibetes
//
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
import SwiftForms
class ActibetesEntryController: FormViewController {
    let actibetesEntryReference = Firebase(url: "https://blazing-heat-3640.firebaseio.com/actibetes-entries")
    
    var actibetesEntry:ActibetesEntry?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        //setup 'accept'button on right hand side of nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Accept", style: UIBarButtonItemStyle.Plain, target: self, action: "doSomething")
        //form setup
        setupUserForm()
//        form +++ Section("Actibetes Entry")
//            <<< DecimalRow("bloodGlucoseLevel"){
//                $0.title = "Blood Glucose"
//                $0.placeholder = "mmol/L"
//                let formatter = NSNumberFormatter()
//                formatter.positiveSuffix = " mmol/L"
//                $0.formatter = formatter
//        }
//            <<< IntRow("carbs"){
//                $0.title = "Carbs"
//                $0.placeholder = "g"
//                let formatter = NSNumberFormatter()
//                formatter.positiveSuffix = "g"
//                $0.formatter = formatter
//        }
//            <<< TextRow("mealDescription"){
//                $0.title = "Meal description"
//                $0.placeholder = "Meal details"
//        }
        // Do any additional setup after loading the view, typically from a nib.
        

        
    }
    
//    func doSomething(){
//        let formDict = form.values()
//        let actibetesEntry = ActibetesEntry()
//        actibetesEntry.bloodGlucoseLevel = formDict["bloodGlucoseLevel"] as? Float
//        actibetesEntry.carbs = formDict["carbs"] as? Int
//        actibetesEntry.mealDescription = formDict["mealDescription"] as? String
//        print(actibetesEntry.bloodGlucoseLevel)
//        
//       let actibetesEntryRef = self.actibetesEntryReference.childByAutoId()
//        actibetesEntryRef.setValue(actibetesEntry.toAnyObject())
//        
//    }
//    func validateFormEntries(dict: Dictionary<String,Any?>){
//        let digitRule = ValidationRulePattern(pattern: .ContainsNumber, failureError: ValidationError(message: "😫"))
//        //Validator.validate(input: dict["bloodGlucoseLevel"] as? Float, rule: digitRule)
//        
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupUserForm(){
        let actibetesEntryForm = FormDescriptor()
        actibetesEntryForm.title = "Actibetes Entry Form"
        let section1 = FormSectionDescriptor()
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: "BG", rowType: .Decimal, title: "Blood Glucose")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "mmol/L", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
//        row = FormRowDescriptor(tag: Static.passwordTag, rowType: .Password, title: "Password")
//        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter password", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
//        section1.addRow(row)
        
        actibetesEntryForm.sections = [section1]
        self.form = actibetesEntryForm
    }

    

}



