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
  
  var tableViewController = UITableViewController()
  
  @IBOutlet weak var loadingLabel: UILabel!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet var appsTableView : UITableView?
  @IBOutlet var introView : UIView?
  @IBOutlet weak var progressView: UIProgressView!
  
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
    
    self.segmentedControl.tintColor = UIColor.whiteColor()

    /*
    
    // setting a color of inactive icon in tabbar
    for item in tabBarController?.tabBar.items as [UITabBarItem] {
      if let image = item.image {
        item.image = image.imageWithColor(UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)).imageWithRenderingMode(.AlwaysOriginal)
      }
    }
*/
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
//    self.appsTableView?.alpha = 0
//    self.introView?.alpha = 1
//    self.segmentedControl.hidden = true
    
    model.loadApplicationsList()
    self.tableData = model.data
    
  }
  
  func loadingCompleted(data: AnyObject) {
//    self.segmentedControl.hidden = false
    self.allData = data as [ApplicationItem]
    self.tableData = data as [ApplicationItem]
    self.appsTableView!.reloadData()
    
    var sharedValues : NSUserDefaults = NSUserDefaults(suiteName: "group.ucApplicationsSharingValues")!
    sharedValues.setInteger(self.allData.count, forKey: "totalApplications")
    
/*
    UIView.animateWithDuration(0.5, animations: {
      self.introView?.alpha = 0
      self.appsTableView?.alpha = 1
    })
*/

    var formatter = NSDateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    var date = NSDate()
    var title = NSString(format: "Last update: %@", formatter.stringFromDate(date))
    var attrsDictionary = NSDictionary(object: UIColor.darkTextColor(), forKey: NSForegroundColorAttributeName)
    
    var attributedTitle = NSAttributedString(string: title, attributes: attrsDictionary)
    self.refreshControl.attributedTitle = attributedTitle
    
    self.refreshControl.endRefreshing()


  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if (self.tableData.count > 0)
    {
      self.segmentedControl.hidden = false
      self.appsTableView?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
      
      return 1
      
    } else {
      self.segmentedControl.hidden = true
      var messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
      messageLabel.text = "No data is currently available. Please pull down to refresh."
      messageLabel.textColor = UIColor.darkTextColor()
      messageLabel.numberOfLines = 0
      messageLabel.textAlignment = NSTextAlignment.Center
      messageLabel.font = UIFont(name: "Arial", size: 16)
      messageLabel.sizeToFit()
      
      self.appsTableView?.backgroundView = messageLabel
      self.appsTableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        
      return 0
    }
  }
  
  func updateProgress(progress: Float) {
    //self.progressView.progress = progress
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
    df.dateFormat = "MMM d, h:mm a"

    cell.textLabel?.text = rowData.name
    cell.detailTextLabel?.text = "\(df.stringFromDate(rowData.date!))"
    
    if (rowData.stateType == "INITIAL") { cell.imageView?.image = UIImage(named: "Initial") }
    else if (rowData.stateType == "ACTIVE") { cell.imageView?.image = UIImage(named: "Active") }
    else if (rowData.state == "Přijat ke studiu") { cell.imageView?.image = UIImage(named: "Final") }
    else { cell.imageView?.image = UIImage(named: "FinalAlternative") }
    
    return cell
  }
  
  
}

