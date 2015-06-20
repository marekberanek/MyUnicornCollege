//
//  ViewController.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 14.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit
import CoreData

extension String
{
  func replace(target: String, withString: String) -> String
  {
    return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
  }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApplicationsModelDelegate {
  var tableData: [DBApplicationItem] = []
  var allData: [DBApplicationItem] = []
  var processed : Bool = false
  
  var tableViewController = UITableViewController()

  let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet var appsTableView : UITableView?
  @IBOutlet var messageLabel : UILabel?
  
  var maxCount : Int = 0
  var totalCount : Int = 0
  
  var refreshControl = UIRefreshControl()

  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    tableViewController.tableView = self.appsTableView
    
    // setting a background color of UITable refresh control
    self.refreshControl = UIRefreshControl()
    self.refreshControl.backgroundColor = UIColor(red: 247.0 / 255.0, green: 247.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
    self.refreshControl.tintColor = UIColor.darkTextColor()
    self.refreshControl.addTarget(self, action: "loadApplications", forControlEvents: UIControlEvents.ValueChanged)
    tableViewController.refreshControl = self.refreshControl
    
    self.appsTableView?.estimatedRowHeight = 44.0
    self.appsTableView?.rowHeight = UITableViewAutomaticDimension
  }
    
  func loadApplications()
  {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var model = appDelegate.applicationsModel
    
    model.delegate = self
    
    self.tableData = []
    
    /* for testing purposes only, call loadApplicationsListDummy() */

    //model.loadApplicationsList()
    model.loadApplicationsListDummy(managedObjectContext!)
    
  }
  
  func loadingCompleted(data: AnyObject) {
    self.allData = data as! [DBApplicationItem]
    self.tableData = data as! [DBApplicationItem]
    
    var sharedValues : NSUserDefaults = NSUserDefaults(suiteName: "group.ucApplicationsSharingValues")!
    sharedValues.setInteger(self.allData.count, forKey: "totalApplications")
    sharedValues.setInteger(self.allData.filter { a in
      a.language == "čeština" }.count, forKey: "czechApplications")
    sharedValues.setInteger(self.allData.filter { a in
      a.language == "angličtina" }.count, forKey: "englishApplications")
    
    applyFilter()
    
    var formatter = NSDateFormatter()
    formatter.dateFormat = "MMM d, HH:mm"
    var date = NSDate()
    var title = NSString(format: "Last update: %@", formatter.stringFromDate(date))
    var attrsDictionary = NSDictionary(object: UIColor.darkTextColor(), forKey: NSForegroundColorAttributeName)
    
    var attributedTitle = NSAttributedString(string: title as String, attributes: attrsDictionary as [NSObject : AnyObject])
    self.refreshControl.attributedTitle = attributedTitle
    
    self.refreshControl.endRefreshing()
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if (self.allData.count > 0)
    {
//      self.segmentedControl.hidden = false
      self.appsTableView?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
      messageLabel?.hidden = true
      
      return 1
      
    } else {
//      self.segmentedControl.hidden = true
      messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
      messageLabel?.text = "No data is currently available. Please pull down to refresh."
      messageLabel?.textColor = UIColor.darkTextColor()
      messageLabel?.numberOfLines = 0
      messageLabel?.textAlignment = NSTextAlignment.Center
      messageLabel?.font = UIFont(name: "Arial", size: 16)
      messageLabel?.sizeToFit()
      
      self.appsTableView?.backgroundView = messageLabel
      self.appsTableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    return 0
  }
  
  func applyFilter()
  {
    var filteredData : [DBApplicationItem] = []
    
    switch segmentedControl.selectedSegmentIndex
    {
    case 0:
      self.tableData = self.allData
      self.appsTableView!.reloadData()
    case 1:
      self.tableData = self.allData.filter { a in
        a.language == "čeština" }
      self.appsTableView!.reloadData()
    case 2:
      self.tableData = self.allData.filter { a in
        a.language == "angličtina" }
      self.appsTableView!.reloadData()
    default:
      break
    }
  }
  
  func updateProgress(progress: Float) {
    //self.progressView.progress = progress
  }
  
  func loadingError(error: String) {
    self.refreshControl.endRefreshing()

    
    let alert = UIAlertController(title: "Critical Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }

  @IBAction func indexChanged(sender: UISegmentedControl) {
    applyFilter()
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("ApplicationCell") as! UITableViewCell
    
    let rowData: DBApplicationItem = self.tableData[indexPath.row] as DBApplicationItem
    
    let df = NSDateFormatter()
//    df.dateFormat = "MMM d, h:mm a"
    df.dateFormat = "dd.MM.yyyy, HH:mm"

    cell.textLabel?.text = rowData.name
    cell.detailTextLabel?.text = "\(df.stringFromDate(rowData.date!))"
    
    if (rowData.stateType == "INITIAL") { cell.imageView?.image = UIImage(named: "Initial") }
    else if (rowData.stateType == "ACTIVE") { cell.imageView?.image = UIImage(named: "Active") }
    else if (rowData.state == "Přijat ke studiu") { cell.imageView?.image = UIImage(named: "Final") }
    else { cell.imageView?.image = UIImage(named: "FinalAlternative") }
    
    return cell
  }
  
  
}

