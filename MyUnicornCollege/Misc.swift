//
//  Plus4U.swift
//  MyUnicornCollege
//
//  Created by Marek Beranek on 15.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit

struct pieChartDataStruct {
  var category: UCDescType
  var lang: String
  var count: Int
}

let defaults = NSUserDefaults.standardUserDefaults()
let p4u_user : String? = defaults.stringForKey("access_code1")
let p4u_password : String? = defaults.stringForKey("access_code2")

let UCBlue = UIColor(red: 0.0 / 255.0, green: 40.0 / 255.0, blue: 130.0 / 255.0, alpha: 1)
let UCGreen = UIColor(red: 0.0 / 255.0, green: 135.0 / 255.0, blue: 137.0 / 255.0, alpha: 1)
let UCGreenAdditional = UIColor(red: 0.0 / 255.0, green: 183.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)
let UCGray = UIColor(red: 125.0 / 255.0, green: 125.0 / 255.0, blue: 125.0 / 255.0, alpha: 1)

enum UCChartType: String {
  case FormPie = "formPie"
  case FieldPe = "fieldPie"
  case StateBars = "stateBars"
  case HistoryLines = "historyLines"
}

enum UCDescType: String {
  case FormFT = "Fulltime"
  case FormPT = "Parttime"
  case LangAll = "All"
  case LangCZ = "Czech"
  case LangEN = "English"
}

let descFormFT = "Fulltime"
let descFormPT = "Parttime"
let descLangAll = "All"
let descLangCZ = "Czech"
let descLangEN = "English"

let typeFT = "Prezenční studium"
let typePT = "Kombinované studium"
let langCZ = "čeština"
let langEN = "angličtina"