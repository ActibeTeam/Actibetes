//
//  HomeViewController.swift
//  Actibetes
//
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class HomeViewController: UIViewController {
   // let actibetesEntryReference = Firebase(url: "https://blazing-heat-3640.firebaseio.com/actibetes-entries")
    //let url = "http://192.168.0.9:8080/HammerServer/webapi/world"

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
    

    @IBAction func logoutButton(sender: AnyObject) {
        //actibetesEntryReference.unauth()
        FirebaseDataService.dataService.currentUserReference.unauth()
        // Remove the user's uid from storage.
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//    @IBAction func launchHTTPRequest(sender: UIButton) {
//       
//            let data = ["targetReached_" : true,
//                "robotPosition_" : [
//                    "x" : 0,
//                    "y" : 0
//                ],
//                "goal_": [
//                    "x": 20,
//                    "y": 20
//                ],
//                "robotSpeed_": 1
//            ]
//            Alamofire.request(.POST, url, parameters:data, encoding: .JSON).responseString(completionHandler: { response in
//                debugPrint(response.result.value)
//            })
//        
//        
//    }
}
