//
//  StatsViewController.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 28.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit


class StatsViewController: UIViewController {
  var tableData: [ApplicationItem] = []

  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var initialLabel: UILabel!
  @IBOutlet weak var activeLabel: UILabel!
  @IBOutlet weak var acceptedLabel: UILabel!
  @IBOutlet weak var notAcceptedLabel: UILabel!
  @IBOutlet weak var managementICTLabel: UILabel!

  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    var appsFiltered: [ApplicationItem] = []
    super.viewWillAppear(animated)
    let barViewControllers = self.tabBarController?.viewControllers
    let avc = barViewControllers![0] as ViewController
    self.tableData = avc.tableData

    // get number of applications in Initial stateType
    appsFiltered = []
    appsFiltered = self.tableData.filter { a in
      a.stateType == "INITIAL" }
    initialLabel.text = String(appsFiltered.count)
    
    // get number of applications in Active stateType
    appsFiltered = []
    appsFiltered = self.tableData.filter { a in
      a.stateType == "ACTIVE" }
    activeLabel.text = String(appsFiltered.count)
    
    // get number of applications in Accepted state
    appsFiltered = []
    appsFiltered = self.tableData.filter { a in
      a.state == "Přijat ke studiu" }
    acceptedLabel.text = String(appsFiltered.count)

    // get number of applications in Not Accepted state
    appsFiltered = []
    appsFiltered = self.tableData.filter { a in
      a.state == "Nepřijat ke studiu" }
    notAcceptedLabel.text = String(appsFiltered.count)
    
    // get number of applications in Management ICT projektů field
    appsFiltered = []
    appsFiltered = self.tableData.filter { a in
      a.field == "Management ICT projektů" }
    managementICTLabel.text = String(appsFiltered.count)
    

    totalLabel.text = String(tableData.count)
  }
  
  func updateStats(appsData: [ApplicationItem])
  {
    self.totalLabel.text = String(appsData.count)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setLabel(label: String)
  {
    self.totalLabel.text = label
  }
    
}
