//
//  ApplicationsModel.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 12.03.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//
import Foundation
import Alamofire

protocol ApplicationsModelDelegate {
  func loadingCompleted(data:AnyObject)
  func updateProgress(progress:Float)
  func loadingError(error:String)
}

class ApplicationsModel: NSObject {
  var delegate:ApplicationsModelDelegate!
  var data: [ApplicationItem]
  var processed: Bool = false
  
  override init() {
    data = []
    super.init()
  }
  
  func loadApplicationsList() {
    if (p4u_user != nil && p4u_password != nil) {
      Alamofire.request(.GET, "https://api.unicornuniverse.eu/ues/wcp/ues/core/container/UESFolder/getEntryList?uesuri=ues:UCL-BT:SGC.EPR/1516")
        .authenticate(user: p4u_user!, password: p4u_password!)
        .responseJSON() {
          (_, _, JSON, _) in
          if(JSON != nil){
            self.loadApplicationBasicInfo(JSON!, {
              if (self.processed == true) {
                // all adequate applications are downloaded
                // let's fetch additional information about application
                self.loadApplicationDetailInfo()
              }
            })
          } else {
            self.delegate.loadingError("CREDENTIALS")
          }
      }
    } else {
      self.delegate.loadingError("CREDENTIALS")
    }
  }
  
  func loadApplicationBasicInfo(applications:AnyObject, callback: () -> ()) {
    var tempData: [ApplicationItem] = []
    var appsFiltered: [ApplicationItem] = []
    var maxCount: Int = 0
    var totalCount: Int = 0
    
    self.delegate.updateProgress(0)
    
    tempData = (applications.valueForKey("pageEntries") as [NSDictionary]).map {
      ApplicationItem(id: $0["code"] as String, name: ($0["name"] as String).replace("Přihláška ke studiu ", withString: ""))
    }

    totalCount = tempData.count
    
    for item in tempData {
      (item as ApplicationItem).getBasicInformation({
        if (++maxCount == totalCount) {
          /* all data is downloaded */
          
          appsFiltered = tempData.filter { a in
            a.mar == "UCLMMD/A" && a.stateType != "CANCELLED" }
          
          // data is sorted by id desc
          appsFiltered.sort ({$0.id > $1.id})
          
          self.data = appsFiltered
          self.processed = true
          callback()
        }
        self.delegate.updateProgress(Float(maxCount)/Float(totalCount))
      })
    }
    
  }
  
  func loadApplicationDetailInfo() {
    var maxCount: Int = 0
    var totalCount: Int = 0
    
    self.delegate.updateProgress(0)
    totalCount = self.data.count
    
    for item in self.data {
      (item as ApplicationItem).getAdditionalInformation({
        if (++maxCount == totalCount) {
          /* all data is downloaded */
          self.delegate.loadingCompleted(self.data)
        }
        self.delegate.updateProgress(Float(maxCount)/Float(totalCount))
      })
    }
  }
   
}