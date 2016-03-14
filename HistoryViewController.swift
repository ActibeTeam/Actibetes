//
//  HistoryViewController.swift
//  Actibetes
//
//  Created by Sarah-Jessica Jemitola on 01/03/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import UIKit
import Firebase
import AFDateHelper
class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Properties
    var entryHistoryArray = [ActibetesEntry]()
    var datesArray = [String]()
    var sortedDates = [String]()
    var actibetesEntryDictionary = [String:[ActibetesEntry]]()
    var currentDateKey = ""
    var previousMealTime = ""


    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("history viewDidLoad called")

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
        //get entry history
        let actibetesEntryRef = FirebaseDataService.dataService.currentUserActibetesEntryReference
        actibetesEntryRef.keepSynced(true)
        actibetesEntryRef.queryOrderedByKey().observeEventType(.Value, withBlock: {snapshot in

           
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for entry in snapshots{
              
                    let mealDate = entry.value["mealDate"] as! String
                    let entryDict = entry.value as! [String:AnyObject]
                    let actibetesEntry = ActibetesEntry(dict: entryDict)
                    print(actibetesEntry.carbs)
                    //self.addToDatesArray(mealTime, array: &self.datesArray)
                    if self.actibetesEntryDictionary[mealDate] != nil{
                        self.actibetesEntryDictionary[mealDate]!.append(actibetesEntry)
                    }else{
                        self.actibetesEntryDictionary[mealDate] = []
                        self.actibetesEntryDictionary[mealDate]!.append(actibetesEntry)
                    }
                    
                    
                }
            }
            
            self.sortedDates = Array(self.actibetesEntryDictionary.keys).sort{
                $0 > $1
            }
          
            
            
            self.tableView.reloadData()

           print("Entry \(self.actibetesEntryDictionary.description)")
            print(self.sortedDates)
        })
//        actibetesEntryRef.queryOrderedByChild("mealTime").observeEventType(.ChildAdded, withBlock: {snapshot in
//            let entryDict = snapshot.value as! [String:AnyObject]
//            let actibetesEntry = ActibetesEntry(dict: entryDict)
//            let currentMealTime = snapshot.value["mealTime"] as! String
//            if currentMealTime != self.previousMealTime{
//                self.actibetesEntryDictionary[currentMealTime] = []
//                self.actibetesEntryDictionary[currentMealTime]!.append(actibetesEntry)
//            }else{
//                self.actibetesEntryDictionary[currentMealTime]!.append(actibetesEntry)
//            }
//            
//            print(entryDict.description)
//            
////            self.sortedDates = Array(self.actibetesEntryDictionary.keys).sort{
////                $0 > $1
////            }
//            
//            
//            
//            //self.tableView.reloadData()
//            
//            //print("Entry \(self.actibetesEntryDictionary.description)")
//            //print(self.sortedDates)
//        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //reinitialise previous meal time
        previousMealTime = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateString: String = sortedDates[section]
        let date = NSDate(fromString:  dateString, format: .ISO8601(nil))
        let mediumDateString = date.toString(dateStyle: .MediumStyle, timeStyle: .NoStyle)

        return mediumDateString
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return sortedDates.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sortedDates[section]
        let value = actibetesEntryDictionary[key]
        return value!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = sortedDates[indexPath.section]
        let entry = actibetesEntryDictionary[key]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
        cell.cellBloodGlucoseLabel.text = String(entry![indexPath.row].bloodGlucoseLevel)
        cell.cellCarbsLabel.text = String(entry![indexPath.row].carbs)
        cell.cellTimeLabel.text = entry![indexPath.row].mealTime

        
        return cell

    }
    private func addToDatesArray(dateandTime: AnyObject!, inout array: [String]){
        let dateandTimeString = dateandTime as? String
        if array.contains(dateandTimeString!) == false{
            array.append(dateandTimeString!)
        }
        
    }
    
    private func sortDatesArrayInDescendingOrder(var array:[String]) -> [String]{
        array = array.sort{
            return $0 > $1
        }
        return array
    }
    
//    private func buildSortedActibetesEntriesByDate(dateArray: [String], actibetesEntryArray: [ActibetesEntry]){
//                    for (index, value) in actibetesEntryArray.enumerate(){
//                        if
//                    }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
