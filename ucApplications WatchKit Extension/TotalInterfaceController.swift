//
//  InterfaceController.swift
//  ucApplications WatchKit Extension
//
//  Created by Marek Beránek on 10.03.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import WatchKit
import Foundation


class TotalInterfaceController: WKInterfaceController {

  @IBOutlet weak var countLabel: WKInterfaceLabel!  
  @IBOutlet weak var typeLabel: WKInterfaceLabel!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
      
        // Configure interface objects here.
  }

  override func willActivate() {
      // This method is called when watch view controller is about to be visible to user
      super.willActivate()
      
    updateCount()
  }
  
  func updateCount()
  {
    countLabel.setText(String(getTotal()))
  }
  
  func getTotal() -> Int {
    
    let sharedValues : NSUserDefaults = NSUserDefaults(suiteName: "group.ucApplicationsSharingValues")!
    
    var total = sharedValues.integerForKey("totalApplications")
    
    println(total)

    return total
  }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
