//
//  Plus4U.swift
//  MyUnicornCollege
//
//  Created by Marek Beranek on 15.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import Foundation
import Alamofire


//let p4u_user = "ucl001"
//let p4u_password = "mar123ek9"

let defaults = NSUserDefaults.standardUserDefaults()
let p4u_user : String? = defaults.stringForKey("access_code1")
let p4u_password : String? = defaults.stringForKey("access_code2")
