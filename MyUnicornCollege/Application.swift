//
//  Application.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 14.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class ApplicationItem: NSObject {
  let id: String
  let name: String
  
  var state: String?
  var mar: String?
  var stateType: String?
  var date: NSDate?
  
  var field: String?
  var type: String?
  var language: String?
  var from_where: String?
  var entrance_date: NSDate?
  var scholarship_date: String?
  var sex: String?
  var birth_number: String?
  var citizenship: String?
  var pa_email: String?
  var pa_telephone: String?
  var pa_street: String?
  var pa_town: String?
  var pa_zipcode: String?
  var pa_state: String?
  var ta_street: String?
  var ta_town: String?
  var ta_zipcode: String?
  var ta_state: String?
  var education_background: String?
  
  var error: String?
  
  init(id: String, name: String) {
    self.id = id
    self.name = name
    
    super.init()
  }
  
  //decode JSON file from base64 to string
  private func getJSON(dataBase64: String) -> String {
    let decodedData = NSData(base64EncodedString: dataBase64, options: NSDataBase64DecodingOptions(0))
    
    let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
    return decodedString! as String
  }
  
  
  func isExist(data: [DBApplicationItem], id: String) -> Int {
    var filtered = [DBApplicationItem]()
    
    filtered = data.filter { a in a.id == id }
    
    if (filtered.count == 0) {
      return 0
    } else {
      return 1
    }
  }

  func isExistWithSameState(data: [DBApplicationItem], id: String, state: String) -> Int {
    var filtered = [DBApplicationItem]()
    
    filtered = data.filter { a in a.id == id  && a.state == state}
    
    if (filtered.count == 0) {
      return 0
    } else {
      return 1
    }
  }

  
  func save(data: [DBApplicationItem], managedObjectContext: AnyObject ) {

//    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var entityDescription = NSEntityDescription.entityForName("DBApplicationItem", inManagedObjectContext: managedObjectContext as! NSManagedObjectContext)

    if isExist(data, id: self.id) == 1
    {
    } else {
      
      let newItem = DBApplicationItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext as? NSManagedObjectContext)
      
    //    var newItem = NSEntityDescription.insertNewObjectForEntityForName("DBApplicationItem", inManagedObjectContext: managedObjectContext!) as! DBApplicationItem
      
      newItem.id = self.id
      newItem.name = self.name
      newItem.state = self.state
      newItem.mar = self.mar
      newItem.stateType = self.stateType
      newItem.date = self.date
      newItem.field = self.field
      newItem.type = self.type
      newItem.language = self.language
      newItem.from_where = self.from_where
      newItem.entrance_date = self.entrance_date
      newItem.scholarship_date = self.scholarship_date
      newItem.sex = self.sex
      newItem.birth_number = self.birth_number
      newItem.citizenship = self.citizenship
      newItem.pa_email = self.pa_email
      newItem.pa_telephone = self.pa_telephone
      newItem.pa_street = self.pa_street
      newItem.pa_town = self.pa_town
      newItem.pa_zipcode = self.pa_zipcode
      newItem.pa_state = self.pa_state
      newItem.ta_street = self.ta_street
      newItem.ta_town = self.ta_town
      newItem.ta_zipcode = self.ta_zipcode
      newItem.ta_state = self.ta_state
      newItem.education_background = self.education_background
      
      var error : NSError?
      managedObjectContext.save(&error)
      
      if let err = error {
        println(err.localizedFailureReason)
      }
      
    }

  }
  
  // cast String to NSData
  private func castString2Date(dateString: String, dateFormat: String) -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
  
    return dateFormatter.dateFromString(dateString)
  }
  
  // get basic information about artifact
  func getBasicInformation(callback: () -> ()) {
    var url = "https://api.plus4u.net/ues/wcp/ues/core/artifact/UESArtifact/getAttributes?uesuri=ues:UCL-BT:" + self.id
    
    Alamofire.request(.GET, url)
      .authenticate(user: p4u_user!, password: p4u_password!)
      .responseJSON() {
        (_, response, dataJSON, _) in
        if(dataJSON != nil){
          self.stateType = dataJSON!.valueForKeyPath("stateType") as! String!
          self.date = self.castString2Date(dataJSON!.valueForKeyPath("creationTime") as! String!, dateFormat: "yyyy-MM-dd'T'HH:mm:ss:Z")
          self.mar = self.getArtCode(dataJSON!.valueForKeyPath("metaArtifactUri") as! String!)
          self.state = dataJSON!.valueForKeyPath("stateName") as! String?
          callback()
        } else {
          // if QoS limit is exceeded, repeat a request
          if (response?.statusCode == 429 || response?.statusCode == nil) {
            self.getBasicInformation(callback)
          } else {
            self.error = "BASIC_INFORMATION"
            println("\(self.id): \(self.error)")
          }
        }
    }
  }
  
  // get JSON file with an additional information
  func getAdditionalInformation(callback: () -> ()) {
    var url = "https://api.plus4u.net/ues/wcp/ues/core/attachment/UESAttachment/getAttachmentData?uesuri=ues:UCL-BT:\(self.id):APPLICATION_FIELDS"
    
    var jsonString : String = ""
    var jsonData: AnyObject?
    
    if (self.mar == "UCLMMD/A")
    {
    
      let req = Alamofire.request(.GET, url)
      req.authenticate(user: p4u_user!, password: p4u_password!)
      req.responseJSON { (request, response, data, error) in
        if(data != nil) {
          if (data!.valueForKeyPath("dataHandler") == nil)
          {
            jsonData = data
          } else {
            jsonString = self.getJSON(data!.valueForKeyPath("dataHandler") as! String)
            var nsdata: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
            var error: NSError?
            
            jsonData = NSJSONSerialization.JSONObjectWithData(nsdata, options: NSJSONReadingOptions(0), error: &error)
          }
          self.field = jsonData!.valueForKeyPath("field") as! String!
          self.type = jsonData!.valueForKeyPath("type") as! String!
          self.language = jsonData!.valueForKeyPath("language") as! String!
          self.from_where = jsonData!.valueForKeyPath("from_where") as! String!
          self.entrance_date = self.castString2Date(jsonData!.valueForKeyPath("from_where") as! String!, dateFormat: "DD.MM.YYYY")
          self.scholarship_date = jsonData!.valueForKeyPath("scholarship_date") as! String!
          self.sex = jsonData!.valueForKeyPath("sex") as! String!
          self.birth_number = jsonData!.valueForKeyPath("birth_number") as! String!
          self.citizenship = jsonData!.valueForKeyPath("citizenship") as! String!
          self.pa_email = jsonData!.valueForKeyPath("pa_email") as! String!
          self.pa_telephone = jsonData!.valueForKeyPath("pa_telephone") as! String!
          self.pa_street = jsonData!.valueForKeyPath("pa_street") as! String!
          self.pa_town = jsonData!.valueForKeyPath("pa_town") as! String!
          self.pa_zipcode = jsonData!.valueForKeyPath("pa_zipcode") as! String!
          self.pa_state = jsonData!.valueForKeyPath("pa_state") as! String!
          self.ta_street = jsonData!.valueForKeyPath("ta_street") as! String!
          self.ta_town = jsonData!.valueForKeyPath("ta_town") as! String!
          self.ta_zipcode = jsonData!.valueForKeyPath("ta_zipcode") as! String!
          self.ta_state = jsonData!.valueForKeyPath("ta_state") as! String!
          self.education_background = jsonData!.valueForKeyPath("education_background") as! String!
          
          callback()
        } else {
          println(response?.statusCode)
          // if QoS limit is exceeded, repeat a request
          if (response?.statusCode == 429 || response?.statusCode == nil) {
            self.getAdditionalInformation(callback)
          } else {
            self.error = "ADDITIONAL_INFORMATION"
            println("\(self.id): \(self.error): \(error)")
          }
        }
      }
    }
  }
  
  // return artifact code from uesuri
  func getArtCode(uesuri: String) -> String {
    
    var artcodeuri = uesuri.componentsSeparatedByString(":")[2]
    
    var startIn = count(artcodeuri.utf16)-19
    //    var startIn = artcodeuri.utf16Count-19
    var artcode = ""
    
    artcode = artcodeuri.substringWithRange(Range<String.Index>(start:artcodeuri.startIndex, end:advance(artcodeuri.endIndex, -19)))

    return artcode
  }
  
}




