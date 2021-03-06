//
//  ApplicationsModel.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 12.03.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//
import Foundation
import CoreData
import Alamofire

protocol ApplicationsModelDelegate {
  func loadingCompleted(data:AnyObject)
  func updateProgress(progress:Float)
  func loadingError(error:String)
}



class ApplicationsModel: NSObject {
  var delegate:ApplicationsModelDelegate!
  var data: [ApplicationItem]
  var persistentData = [DBApplicationItem]()
  var processed: Bool = false
  
  override init() {
    data = []
    persistentData = []
    super.init()
  }
  
  private func removePersistentDataAll(context: AnyObject)
  {
    var error : NSError? = nil

    var fetchRequest = NSFetchRequest(entityName: "DBApplicationItem")
    fetchRequest.includesPropertyValues = false
    
    var fetchedObjects = [DBApplicationItem]()
    
    fetchedObjects = context.executeFetchRequest(fetchRequest, error: nil) as! [DBApplicationItem]
    
    for object1 in fetchedObjects
    {
      context.deleteObject(object1)
    }
    
    context.save(&error)
  }
  
  // fetch data from persistent data storage
  private func initializePersistentData(managedObjectContext: AnyObject?)
  {
    var error : NSError? = nil
    
//    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
  
    var fetchRequest = NSFetchRequest(entityName: "DBApplicationItem")
    persistentData = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [DBApplicationItem]
    
  }
  
  func loadApplicationsListDummy(moc: AnyObject)
  {
    
    // Only for testing purpose
    removePersistentDataAll(moc)

    initializePersistentData(moc)
    
    var applications : [ApplicationItem] = []
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss:Z"
    
    
    var application = ApplicationItem(id: "uca001", name: "Beránek Marek")
    application.mar = "UCLMMD/A"
    application.state = "Založena"
    application.stateType = "INITIAL"
    application.date = dateFormatter.dateFromString("2014-11-28T09:41:58+01:00")
    application.field = "Management ICT projektů"
    application.type = "Prezenční studium"
    application.language = "čeština"
    application.save(persistentData, managedObjectContext: moc)
    applications.append(application)
    

    application = ApplicationItem(id: "uca002", name: "Čadil Jan")
    application.mar = "UCLMMD/A"
    application.state = "Přijat ke studiu"
    application.stateType = "FINAL"
    application.date = dateFormatter.dateFromString("2015-03-01T09:41:58+01:00")
    application.field = "Ekonomika a management"
    application.type = "Kombinované studium"
    application.language = "čeština"
    application.save(persistentData, managedObjectContext: moc)
    applications.append(application)

    application = ApplicationItem(id: "uca003", name: "Zouhar Ondřej")
    application.mar = "UCLMMD/A"
    application.state = "Zaevidována"
    application.stateType = "ACTIVE"
    application.date = dateFormatter.dateFromString("2015-03-20T19:41:58+01:00")
    application.field = "Informační technologie"
    application.type = "Prezenční studium"
    application.language = "čeština"
    application.save(persistentData, managedObjectContext: moc)
    applications.append(application)

    application = ApplicationItem(id: "uca004", name: "Novák Jan")
    application.mar = "UCLMMD/A"
    application.state = "Zaevidována"
    application.stateType = "ACTIVE"
    application.date = dateFormatter.dateFromString("2015-03-21T09:41:58+01:00")
    application.field = "Ekonomika a management"
    application.type = "Prezenční studium"
    application.language = "angličtina"
    application.save(persistentData, managedObjectContext: moc)
    applications.append(application)

    application = ApplicationItem(id: "uca005", name: "Nováková Jana")
    application.mar = "UCLMMD/A"
    application.state = "Nedostavil se"
    application.stateType = "ALTERNATIVE_FINAL"
    application.date = dateFormatter.dateFromString("2015-03-21T09:41:58+01:00")
    application.field = "Ekonomika a management"
    application.type = "Prezenční studium"
    application.language = "čeština"
    application.save(persistentData, managedObjectContext: moc)
    applications.append(application)

    
    application = ApplicationItem(id: "uca006", name: "Smith Jon")
    application.mar = "UCLMMD/A"
    application.state = "Zaevidována"
    application.stateType = "ACTIVE"
    application.date = dateFormatter.dateFromString("2015-03-21T09:41:58+01:00")
    application.field = "Informační technologie"
    application.type = "Prezenční studium"
    application.language = "angličtina"
    application.save(persistentData, managedObjectContext: moc)
    applications.append(application)

    application = ApplicationItem(id: "uca008", name: "Smith Peter")
    application.mar = "UCLMMD/A"
    application.state = "Zaevidována"
    application.stateType = "ACTIVE"
    application.date = dateFormatter.dateFromString("2015-03-21T09:41:58+01:00")
    application.field = "Informační technologie"
    application.type = "Prezenční studium"
    application.language = "angličtina"
    application.save(persistentData, managedObjectContext: moc)
    applications.append(application)

    initializePersistentData(moc)

    self.delegate.loadingCompleted(self.persistentData)
  }
  
  // Step 1: Get list of all possible applications stored in defined folder
  func loadApplicationsList() {
    if (p4u_user != nil && p4u_password != nil) {
      Alamofire.request(.GET, "https://api.unicornuniverse.eu/ues/wcp/ues/core/container/UESFolder/getEntryList?uesuri=ues:UCL-BT:SGC.EPR/1516")
        .authenticate(user: p4u_user!, password: p4u_password!)
        .responseJSON() {
          (_, _, JSON, _) in
          if(JSON != nil){
            self.loadApplicationBasicInfo(JSON!, callback: {
              if (self.processed == true) {
                /* all data is downloaded */

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
  
  // Step 2: Retrieve basic properties of application
  func loadApplicationBasicInfo(applications:AnyObject, callback: () -> ()) {
    var tempData: [ApplicationItem] = []
    var appsFiltered: [ApplicationItem] = []
    var maxCount: Int = 0
    var totalCount: Int = 0
    
    self.delegate.updateProgress(0)
    
    tempData = (applications.valueForKey("pageEntries") as! [NSDictionary]).map {
      ApplicationItem(id: $0["code"] as! String, name: ($0["name"] as! String).replace("Přihláška ke studiu ", withString: ""))
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
//        self.delegate.updateProgress(Float(maxCount)/Float(totalCount))
      })
    }
    
  }
  
  // Step 3: Download JSON with detailed information
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
