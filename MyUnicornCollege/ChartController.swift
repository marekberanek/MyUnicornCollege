//
//  pieChartController.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 22.03.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit

class ChartController: UIViewController {

  @IBOutlet weak var countLabel: UILabel!
  
  var itemIndex: Int = 0
  var chartType: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    countLabel.text = chartType

      // Do any additional setup after loading the view.
    
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
