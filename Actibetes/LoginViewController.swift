//
//  LoginViewController.swift
//  Actibetes
//
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    let login = "LoginToHome"
    //let actibetesRootReference = Firebase(url: "https://blazing-heat-3640.firebaseio.com/")
   // let actibetesUsersReference = Firebase(url: "https://blazing-heat-3640.firebaseio.com/users")
    
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    @IBAction func loginDidTouch(sender: AnyObject) {
        FirebaseDataService.dataService.rootReference.authUser(textFieldEmail.text,
            password: textFieldPassword.text, withCompletionBlock:
            {(error, auth) in
                if auth != nil{
                    self.performSegueWithIdentifier(self.login, sender: nil)
                }else{
                    print(error.description)
                }
        })
    }
    
    @IBAction func signUpButtonTouched(sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
            message: "Register",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                let nameField = alert.textFields![0]
                let emailField = alert.textFields![1]
                let passwordField = alert.textFields![2]
                
                FirebaseDataService.dataService.rootReference.createUser(emailField.text,
                    password: passwordField.text, withValueCompletionBlock:
                    {error, result in
                        if error == nil{
                            //save unique user id
                            let uid = result["uid"] as? String
                            NSUserDefaults.standardUserDefaults().setValue(uid, forKey: "uid")
                            
                            
                            let newUser = ["emailaddress": emailField.text!,
                                "name": nameField.text!
                                ]
                                
                            FirebaseDataService.dataService.createNewUserAccount(newUser)
                            
                            
                            /*set email and password in login view so we don't have
                            to enter them twice*/
                            self.textFieldEmail.text = emailField.text
                            self.textFieldPassword.text = passwordField.text
                        }else{
                            //what went wrong?
                            print(error.description)
                        }
                        
                })
                
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textName) -> Void in
            textName.placeholder = "Enter your name"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
