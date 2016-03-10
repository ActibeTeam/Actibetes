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
    let url = "http://129.31.239.185:8080/HammerServer/webapi/user/reco"

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = self.revealViewController()
        menuBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Do any additional setup after loading the view.
        
        activityIndicatorView.hidden = true
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
        //alertUserforGlucoseInput()
        getRecommendation()
        
    }
    
    private func getRecommendation(){
        activityIndicatorView.hidden = false

        activityIndicatorView.startAnimating()
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let dictData = ["userID":userID]
        //var jsonData = self.buildJsonData(dictData as! [String:AnyObject])

        //fire off request
        Alamofire.request(.POST, self.url, parameters:dictData, encoding: .JSON).responseJSON(completionHandler: { response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                let userID = json["userID"].stringValue
                let recommendationMessage = json["msg"].stringValue
                
                print(response)
                let message = recommendationMessage
                let resultAlert: UIAlertController = UIAlertController(title: "Success!", message: message, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                    
                }
                resultAlert.addAction(OKAction)
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.hidden = true

                self.presentViewController(resultAlert, animated: true, completion:nil)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        })
        
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
