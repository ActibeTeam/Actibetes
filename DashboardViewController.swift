//
//  DashboardViewController.swift
//  Actibetes
//
//  Created by Sarah-Jessica Jemitola on 08/03/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import UIKit
import Charts
//import SOMotionDetector
class DashboardViewController: UIViewController, SOMotionDetectorDelegate {
    
    var counter: Int = 0
    var maxAverageSpeed: Double = 0
    var currentAverageSpeed: Double = 0
    var locationUpdatesReceived: Double = 0
    var currentMotionType: SOMotionType?
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var bloodGlucoseGauge: LMGaugeView!
    @IBOutlet weak var caloriesGauge: LMGaugeView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
    

        //setup sidebar menu
        menuBtn.target = self.revealViewController()
        menuBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        //setup blood glucose gauge
        bloodGlucoseGauge.valueTextColor = UIColor.blackColor()
        bloodGlucoseGauge.value = 5.1
        bloodGlucoseGauge.valueFont = UIFont(name: "Helvetica Neue", size: 26)
        bloodGlucoseGauge.ringBackgroundColor = UIColor.blackColor()
        bloodGlucoseGauge.valueTextColor = UIColor.blackColor()
        bloodGlucoseGauge.unitOfMeasurement = "mmol/L"
        bloodGlucoseGauge.unitOfMeasurementTextColor = UIColor.blackColor()
        
        //setup claories gauge
        caloriesGauge.valueTextColor = UIColor.blackColor()
        caloriesGauge.value = 20
        caloriesGauge.valueFont = UIFont(name: "Helvetica Neue", size: 26)
        caloriesGauge.ringBackgroundColor = UIColor.blackColor()
        caloriesGauge.valueTextColor = UIColor.blackColor()
        caloriesGauge.unitOfMeasurement = "calories"
        caloriesGauge.unitOfMeasurementTextColor = UIColor.blackColor()
        
        
        //let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "July"]
        let days = ["Mar 3", "Mar 4", "Mar 5", "Mar 6", "Mar 7", "Mar 8", "Today"]
        
        let bgLevel = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 2.0]
        setupChart(days, yValues: bgLevel)
        
        //motion detection
        SOMotionDetector.sharedInstance().startDetection()
        var timer = NSTimer()

        var firstPass = false
        var prevMotion: SOMotionType!
        SOLocationManager.sharedInstance()
        SOMotionDetector.sharedInstance().setMaximumRunningSpeed(CGFloat(60.0))
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
        
        SOStepDetector.sharedInstance().startDetectionWithUpdateBlock({
            error in
            print("taking steps")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupChart(xValues: [String], yValues:[Double]){
        lineChartView.descriptionText = "Daily average blood glucose"
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        lineChartView.dragEnabled = true
        lineChartView.xAxis.setLabelsToSkip(0)
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<xValues.count {
            let dataEntry = ChartDataEntry(value: yValues[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Blood Glucose Level")
        let lineChartData = LineChartData(xVals: xValues, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
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
        let exercisDict = [
        "caloriesBurned": caloriesBurned,
        "activityDuration": activityDurationMinutes,
        "metValue": metValue
        ]
        exerciseRef.childByAutoId().setValue(exercisDict)
    }

    func resetAverageSpeedAndLocationUpdatesReceived(){
        self.currentAverageSpeed = 0
        self.locationUpdatesReceived = 0
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