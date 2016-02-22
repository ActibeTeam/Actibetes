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
class ActibetesTableViewController: FormViewController {
    
    let actibetesEntryReference = Firebase(url: "https://blazing-heat-3640.firebaseio.com/actibetes-entries")
    
    var actibetesEntry:ActibetesEntry?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //form setup
        self.setupUserForm()
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
        
        let message = self.form.formValues()
        print(message.description)
        let ref = actibetesEntryReference.childByAutoId()
        ref.setValue(message)
        let successMessage = "Your entry was submitted successfully."
        let alert: UIAlertController = UIAlertController(title: "Success!", message: successMessage, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            
        }
        alert.addAction(OKAction)
        
        self.presentViewController(alert, animated: true, completion:nil)
        //alert.show()
    }
    
    
    private func setupUserForm(){
        let actibetesEntryForm = FormDescriptor()
        actibetesEntryForm.title = "Actibetes Daily Entry"
        let section1 = FormSectionDescriptor()
        section1.headerTitle = "Actibetes Information"
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: "BG", rowType: .Decimal, title: "Blood Glucose")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "mmol/L", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: "activityDuration", rowType: .Number, title: "Duration of Activity")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "minutes", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        let section2 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: "notes", rowType: .MultilineText, title: "Notes")
        section2.addRow(row)
        
        
        
        actibetesEntryForm.sections = [section1, section2]
        self.form = actibetesEntryForm
    }
    
}
