//
//  DBApplicationItem.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 13.06.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import Foundation
import CoreData

@objc(DBApplicationItem)

class DBApplicationItem: NSManagedObject {

    @NSManaged var country: String?
    @NSManaged var field: String?
    @NSManaged var id: String
    @NSManaged var language: String?
    @NSManaged var mar: String?
    @NSManaged var name: String
    @NSManaged var state: String?
    @NSManaged var stateType: String?
    @NSManaged var date: NSDate?
    @NSManaged var type: String?
    @NSManaged var from_where: String?
    @NSManaged var entrance_date: NSDate?
    @NSManaged var scholarship_date: String?
    @NSManaged var sex: String?
    @NSManaged var birth_number: String?
    @NSManaged var citizenship: String?
    @NSManaged var pa_email: String?
    @NSManaged var pa_telephone: String?
    @NSManaged var pa_state: String?
    @NSManaged var pa_street: String?
    @NSManaged var pa_town: String?
    @NSManaged var pa_zipcode: String?
    @NSManaged var ta_street: String?
    @NSManaged var ta_town: String?
    @NSManaged var ta_zipcode: String?
    @NSManaged var ta_state: String?
    @NSManaged var education_background: String?

}
