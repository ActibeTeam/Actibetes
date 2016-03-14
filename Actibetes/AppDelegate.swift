//
//  AppDelegate.swift
//  Actibetes
//

//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
import AFDateHelper
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: Properties
    var counter: Int = 0
    var maxAverageSpeed: Double = 0
    var currentAverageSpeed: Double = 0
    var locationUpdatesReceived: Double = 0
    var currentMotionType: SOMotionType?
    
    var window: UIWindow?
    //var actibetesRootReference: Firebase?
    override init() {
        super.init()
        Firebase.defaultConfig().persistenceEnabled = true
        
//        let path = NSBundle.mainBundle().pathForResource("FirebaseProperties", ofType: "plist")
//        let dict = NSDictionary(contentsOfFile: path!)
//        let firebaseRootUrl = dict?.valueForKey("firebaseRootUrl") as! String
//        actibetesRootReference  = Firebase(url: firebaseRootUrl)
        
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginView")
        //Override point for customization after application launch.
        if FirebaseDataService.dataService.rootReference.authData != nil {
            // user authenticated
            print(FirebaseDataService.dataService.rootReference.authData)
            
     
            let revealViewController = storyboard.instantiateViewControllerWithIdentifier("revealViewController")
            self.window?.rootViewController = revealViewController
            
        } else {
            
            //show login view
            
            
            self.window?.rootViewController = loginViewController
            self.window?.makeKeyAndVisible()
        }
        FirebaseDataService.dataService.rootReference.observeAuthEventWithBlock({(authData) in
            if authData == nil{
                //
                print("authdata is nil")
                //show login view
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginView")
                //
                
                
                self.window?.rootViewController = loginViewController
                self.window?.makeKeyAndVisible()
            }
        })
        
        //start activity detection
        activateActivityMonitor()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func activateActivityMonitor(){
        
        //ios9 support
        SOLocationManager.sharedInstance().allowsBackgroundLocationUpdates = true
        //M7? Use it
        SOMotionDetector.sharedInstance().useM7IfAvailable = true
        
        //start motion detection
        SOMotionDetector.sharedInstance().startDetection()
        
        
        
        var timer = NSTimer()
        var firstPass = false
        var prevMotion: SOMotionType!
        SOMotionDetector.sharedInstance().setMaximumRunningSpeed(CGFloat(15.0))
        SOMotionDetector.sharedInstance().motionTypeChangedBlock = {motion in
            var type = "blah"
            switch (motion) {
            case .MotionTypeNotMoving:
                type = "Not moving"
            case .MotionTypeWalking:
                type = "Walking"
            case .MotionTypeRunning:
                type = "Running"
            case .MotionTypeAutomotive:
                type = "Automotive"
                
            }
            print(type)
            
            //there's a bug, can't figure out if it's with the simulator or the library. On app start, it trigeers this motion type changed block
            //which fires using the last known motion type of the user. So if user was running, it fires with motion type-running on application start
            //so I'm just using this firstPass boolean as a temporary fix to disregard the first event that triggers this block
            if firstPass == false{
                firstPass = true
            }else{
                if motion == SOMotionType.MotionTypeRunning{
                    self.currentMotionType = SOMotionType.MotionTypeRunning
                    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateCounter", userInfo: nil, repeats: true)
                    
                    //if we were running and then we started walking/stopped moving
                }else if prevMotion == SOMotionType.MotionTypeRunning && motion != SOMotionType.MotionTypeRunning{
                    self.currentMotionType = motion //set current motion type
                    print("Time spent running \(self.counter)")
                    self.storeExerciseInDatabase(self.counter)
                    self.resetAverageSpeedAndLocationUpdatesReceived()
                    timer.invalidate()
                    self.counter = 0 //reset counter so we can start counting from 0 when user starts running again
                    
                }
                prevMotion = motion
            }
            
            
        }
        SOMotionDetector.sharedInstance().locationChangedBlock = {location in
            if self.currentMotionType == .MotionTypeRunning{
                
                //cumulative moving average
                self.currentAverageSpeed = (location.speed + (self.locationUpdatesReceived*self.currentAverageSpeed))/(self.locationUpdatesReceived + 1)
                self.locationUpdatesReceived++
                print("current average speed is \(self.currentAverageSpeed)")
                
            }
            
            
        }

    }
    
    
    func updateCounter(){
        self.counter++
    }
    
    func storeExerciseInDatabase(activityDuration: Int){
        print("current average speed in function \(self.currentAverageSpeed)")
        let metValue = METCalculator.calculator.convertRunningSpeedToMET(CGFloat(self.currentAverageSpeed))
        let activityDurationMinutes: Double = Double(activityDuration)/60
        let caloriesBurned = CalorieCalculator.calculator.calculateCaloriesBurned(metValue, bodyWeight: User.actibetesUser.weight, activityDurationInMinutes: activityDurationMinutes)
        print("Calories burned in \(activityDurationMinutes)min is \(caloriesBurned)")
        let exerciseRef = FirebaseDataService.dataService.currentUserReference.childByAppendingPath("exercise")
        var exerciseDict: [String:AnyObject] = [
            "caloriesBurned": caloriesBurned,
            "activityDuration": activityDurationMinutes,
            "metValue": metValue
        ]
        appendDateAndTimeToExerciseEntry(&exerciseDict)
        exerciseRef.childByAutoId().setValue(exerciseDict)
    }
    
    func resetAverageSpeedAndLocationUpdatesReceived(){
        self.currentAverageSpeed = 0
        self.locationUpdatesReceived = 0
    }
    
    func appendDateAndTimeToExerciseEntry(inout dict: [String:AnyObject]){
        //set date and time
        let currentDateAndTime = NSDate()
        let exerciseDate: String = currentDateAndTime.toString(format: .ISO8601(ISO8601Format.Date))
        let exerciseHour: String = String(currentDateAndTime.hour())
        let intMinute: Int = currentDateAndTime.minute()
        var exerciseMinute: String
        if intMinute < 10{
            let minuteString: String = String(intMinute)
            exerciseMinute = "0"+minuteString
        }else{
            exerciseMinute = String(intMinute)
        }
        
        let exerciseTime: String = "\(exerciseHour):\(exerciseMinute)"
        dict["exerciseDate"] = exerciseDate
        dict["exerciseTime"] = exerciseTime
        dict["exerciseDateAndTimeEpoch"] = currentDateAndTime.timeIntervalSince1970
        
    }

    
}

