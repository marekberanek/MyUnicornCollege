//
//  ViewController.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 14.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit
import Alamofire

extension String
{
  func replace(target: String, withString: String) -> String
  {
    return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
  }
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//  var tableData: NSArray = []
//  var tempData: NSArray = []
  
  var tableData: [ApplicationItem] = []
  var allData: [ApplicationItem] = []
  var tempData: [ApplicationItem] = []
  var sortName : String = "asc"
  var sortId : String = "desc"
  var processed : Bool = false

 
  @IBOutlet weak var loadingLabel: UILabel!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet var appsTableView : UITableView?
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet var introView : UIView?
  @IBOutlet weak var progressView: UIProgressView!
  
  var maxCount : Int = 0
  var totalCount : Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.appsTableView?.estimatedRowHeight = 44.0
    self.appsTableView?.rowHeight = UITableViewAutomaticDimension

    // load applications from Plus4U
    getApplications()
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }

  @IBAction func indexChanged(sender: UISegmentedControl) {
    var filteredData : [ApplicationItem] = []
    
    switch segmentedControl.selectedSegmentIndex
    {
    case 0:
      if (self.tableData != []) {
        self.tableData = self.allData
        self.appsTableView!.reloadData()
      }
    case 1:
      if (self.tableData != []) {
        self.tableData = self.allData.filter { a in
          a.language == "čeština" }
        self.appsTableView!.reloadData()
      }
    case 2:
      if (self.tableData != []) {
        self.tableData = self.allData.filter { a in
          a.language == "angličtina" }
        self.appsTableView!.reloadData()
      }
    default:
      break
    }

  }

  @IBAction func UpInside(sender: AnyObject) {
    getApplications()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("ApplicationCell") as UITableViewCell
    
    let rowData: ApplicationItem = self.tableData[indexPath.row] as ApplicationItem
    
    let df = NSDateFormatter()
    df.dateFormat = "yyyy-MM-dd hh:mm"

    cell.textLabel?.text = rowData.name
    cell.detailTextLabel?.text = "\(df.stringFromDate(rowData.date!))"
    
    if (rowData.stateType == "INITIAL") { cell.imageView?.image = UIImage(named: "Initial") }
    else if (rowData.stateType == "ACTIVE") { cell.imageView?.image = UIImage(named: "Active") }
    else if (rowData.state == "Přijat ke studiu") { cell.imageView?.image = UIImage(named: "Final") }
    else { cell.imageView?.image = UIImage(named: "FinalAlternative") }
    
    return cell
  }
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func getApplications()
  {
    self.maxCount = 0
    self.tableData = []
    self.tempData = []
    self.appsTableView?.alpha = 0
    self.introView?.alpha = 1
    self.refreshButton.enabled = false
    self.segmentedControl.enabled = false

    self.processed = false
        
    Alamofire.request(.GET, "https://api.unicornuniverse.eu/ues/wcp/ues/core/container/UESFolder/getEntryList?uesuri=ues:UCL-BT:SGC.EPR/1516")
      .authenticate(user: p4u_user!, password: p4u_password!)
      .responseJSON() {
      (_, _, JSON, _) in
        if(JSON != nil){
          
          self.loadApplicationsBasicInformation(JSON!, {
            if (self.processed == true) {
              // all adequate applications are downloaded
              // let's fetch additional information about application
              self.loadApplicationsAdditionalInformation()
            }

          })
        } else {
          var alert = UIAlertView(title: "No internet connection", message: "Connect to the internet and try again", delegate: nil, cancelButtonTitle: "Ok :/")
          alert.show()
        }
    }
    
  }
 
  func loadApplicationsBasicInformation(value: AnyObject, callback: () -> ())
  {
    var appsFiltered: [ApplicationItem] = []
    
    self.progressView.progress = 0
    //self.loadingLabel.text = "Loading basic information"
    //self.loadingLabel.textAlignment = NSTextAlignment.Center
    
    self.tempData = (value.valueForKey("pageEntries") as [NSDictionary]).map {
      ApplicationItem(id: $0["code"] as String, name: ($0["name"] as String).replace("Přihláška ke studiu ", withString: ""))
    }
    self.maxCount = 0
    self.totalCount = self.tempData.count
    for item in self.tempData{
      (item as ApplicationItem).getBasicInformation({
        if(++self.maxCount==self.totalCount){
         
          /* all data is downloaded */
          
          // data is filtered by MAR and stateType
          appsFiltered = self.tempData.filter { a in
            a.mar == "UCLMMD/A" &&
            a.stateType != "CANCELLED" }
          
          // data is sorted by id desc
          appsFiltered.sort ({$0.id > $1.id})
            
          self.tableData = appsFiltered
          self.allData = self.tableData
          self.processed = true
          callback()
        }
        self.progressView.progress = Float(self.maxCount)/Float(self.totalCount)
      })
    }
    
    
  }
  
  func loadApplicationsAdditionalInformation()
  {
    
    self.maxCount = 0
    self.progressView.progress = 0
    self.totalCount = self.tableData.count
    
    //self.loadingLabel.text = "Loading additional information"
    //self.loadingLabel.textAlignment = NSTextAlignment.Center

    // for each ApplicationItem call getAdditionalInformation
    for item in self.tableData {
      
      (item as ApplicationItem).getAdditionalInformation({
        if(++self.maxCount==self.totalCount){
          
          /* all data is downloaded */
          
          self.refreshButton.enabled = true
          self.segmentedControl.enabled = true
          self.allData = self.tableData
          self.appsTableView!.reloadData()
          
          var sharedValues : NSUserDefaults = NSUserDefaults(suiteName: "group.ucApplicationsSharingValues")!
          sharedValues.setInteger(self.totalCount, forKey: "totalApplications")
          
          UIView.animateWithDuration(0.5, animations: {
            self.introView?.alpha = 0
            self.appsTableView?.alpha = 1
          })
        }
        self.progressView.progress = Float(self.maxCount)/Float(self.totalCount)
      })
    }
    
  }

}

