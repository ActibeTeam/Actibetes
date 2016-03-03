//
//  GoingForRunViewController.swift
//  Actibetes
//
//  Created by Sarah-Jessica Jemitola on 01/03/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GoingForRunViewController: UIViewController {
    let url = "http://129.31.238.213:8080/HammerServer/webapi/user"

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = self.revealViewController()
        menuBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sendDataToServer(sender: AnyObject) {
        alertUserforGlucoseInput()
        
    }
    
    private func alertUserforGlucoseInput(){
        let alert = UIAlertController(title: "Run",
            message: "What's your glucose level?",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Send",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                 let glucoseField = alert.textFields![0]
                var glucoseText = glucoseField.text as! NSString
                var dictData = ["lastGLM_": glucoseText.doubleValue] as NSDictionary
                var jsonData = self.buildJsonData(dictData as! [String:AnyObject])
                
                //fire off request
                Alamofire.request(.POST, self.url, parameters:jsonData, encoding: .JSON).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .Success(let data):
                        let json = JSON(data)
                        let calories = json["ExerciseReco_"].stringValue
                        print(response)
                        let message = "Calories yu need to burn is \(calories)"
                        let resultAlert: UIAlertController = UIAlertController(title: "Success!", message: message, preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                            
                        }
                        resultAlert.addAction(OKAction)
                        
                        self.presentViewController(resultAlert, animated: true, completion:nil)

                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                    }
                })
                
               
                
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textFieldGlucose) -> Void in
            textFieldGlucose.placeholder = "Enter your blood glucose"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
        
    }
    
    func buildJsonData(var data:[String:AnyObject]) -> [String:AnyObject]{
        return data
    }

}
