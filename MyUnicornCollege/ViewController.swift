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


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApplicationsModelDelegate {
  var tableData: [ApplicationItem] = []
  var allData: [ApplicationItem] = []
  var tempData: [ApplicationItem] = []
  var processed : Bool = false
  
  @IBOutlet weak var loadingLabel: UILabel!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet var appsTableView : UITableView?
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet var introView : UIView?
  @IBOutlet weak var progressView: UIProgressView!
  
  var maxCount : Int = 0
  var totalCount : Int = 0
  
  var refreshControl = UIRefreshControl()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.appsTableView?.estimatedRowHeight = 44.0
    self.appsTableView?.rowHeight = UITableViewAutomaticDimension
    
    loadApplications()
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }
  
  func loadApplications()
  {
    var appDelagate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var model = appDelagate.applicationsModel
    
    model.delegate = self
    
    self.tableData = []
    self.tempData = []
    self.appsTableView?.alpha = 0
    self.introView?.alpha = 1
    self.refreshButton.enabled = false
    self.segmentedControl.hidden = true
    
    model.loadApplicationsList()
    self.tableData = model.data
  }
  
  func loadingCompleted(data: AnyObject) {
    self.refreshButton.enabled = true
    self.segmentedControl.hidden = false
    self.allData = data as [ApplicationItem]
    self.tableData = data as [ApplicationItem]
    self.appsTableView!.reloadData()
    
    var sharedValues : NSUserDefaults = NSUserDefaults(suiteName: "group.ucApplicationsSharingValues")!
    sharedValues.setInteger(self.totalCount, forKey: "totalApplications")
    
    UIView.animateWithDuration(0.5, animations: {
      self.introView?.alpha = 0
      self.appsTableView?.alpha = 1
    })

  }
  
  func updateProgress(progress: Float) {
    self.progressView.progress = progress
  }
  
  func loadingError(error: String) {
    let alert = UIAlertController(title: "Critical Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
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
    loadApplications()
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
  
  
}

