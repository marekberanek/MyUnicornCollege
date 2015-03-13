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
                // all adequate applications are downloaded
                // let's fetch additional information about application
                self.loadApplicationDetailInfo()
              
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
    
  }
  
  func loadApplicationDetailInfo() {
    
  }
   
}
