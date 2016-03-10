//
//  DashboardViewController.swift
//  Actibetes
//
//  Created by Sarah-Jessica Jemitola on 08/03/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import UIKit
import Charts
class DashboardViewController: UIViewController, SOMotionDetectorDelegate {

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var bloodGlucoseGauge: LMGaugeView!
    @IBOutlet weak var caloriesGauge: LMGaugeView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        menuBtn.target = self.revealViewController()
        menuBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        

        //gauge.limitValue = 25
        bloodGlucoseGauge.valueTextColor = UIColor.blackColor()
        bloodGlucoseGauge.value = 5.1
        bloodGlucoseGauge.valueFont = UIFont(name: "Helvetica Neue", size: 26)
        bloodGlucoseGauge.ringBackgroundColor = UIColor.blackColor()
        bloodGlucoseGauge.valueTextColor = UIColor.blackColor()
        bloodGlucoseGauge.unitOfMeasurement = "mmol/L"
        bloodGlucoseGauge.unitOfMeasurementTextColor = UIColor.blackColor()
        
        caloriesGauge.valueTextColor = UIColor.blackColor()
        caloriesGauge.value = 20
        caloriesGauge.valueFont = UIFont(name: "Helvetica Neue", size: 26)
        caloriesGauge.ringBackgroundColor = UIColor.blackColor()
        caloriesGauge.valueTextColor = UIColor.blackColor()
        caloriesGauge.unitOfMeasurement = "calories"
        caloriesGauge.unitOfMeasurementTextColor = UIColor.blackColor()


        // Do any additional setup after loading the view.
        //let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "July"]
        let months = ["Mar 3", "Mar 4", "Mar 5", "Mar 6", "Mar 7", "Mar 8", "Today"]

        let bgLevel = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 2.0]
        setupChart(months, yValues: bgLevel)
        
        
        //motion detection
        SOMotionDetector.sharedInstance().startDetection()
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
    
   
    func motionDetector(motionDetector: SOMotionDetector!, motionTypeChanged motionType: SOMotionType) {
        var type = ""
        switch (motionType) {
        case MotionTypeNotMoving:
            type = "Not moving"
        case MotionTypeWalking:
            type = "Walking"
        case MotionTypeRunning:
            type = "Running"
        case MotionTypeAutomotive:
            type = "Automotive"
        default:
            type = "No match"
        }
        print(type)
    }
    
    func motionDetector(motionDetector: SOMotionDetector!, accelerationChanged acceleration: CMAcceleration) {
        print("acceleration")
    }
    func motionDetector(motionDetector: SOMotionDetector!, locationChanged location: CLLocation!) {
        print("location")
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
