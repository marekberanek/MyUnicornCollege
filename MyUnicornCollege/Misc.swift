//
//  Plus4U.swift
//  MyUnicornCollege
//
//  Created by Marek Beranek on 15.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit

struct pieChartDataStruct {
  var category: String
  var lang: UCLang
  var count: Int
  var color: CPTColor
}

let defaults = NSUserDefaults.standardUserDefaults()
let p4u_user : String? = defaults.stringForKey("access_code1")
let p4u_password : String? = defaults.stringForKey("access_code2")

//let UCBlue = UIColor(red: , green: , blue: , alpha: 1)
let UCCPTBlue = CPTColor(componentRed: 0.0 / 255.0, green: 40.0 / 255.0, blue: 130.0 / 255.0, alpha: 1)
let UCCPTGreen = CPTColor(componentRed: 0.0 / 255.0, green: 135.0 / 255.0, blue: 137.0 / 255.0, alpha: 1)
let UCCPTGreenAdditional = CPTColor(componentRed: 0.0 / 255.0, green: 183.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)
let UCCPTGray = CPTColor(componentRed: 125.0 / 255.0, green: 125.0 / 255.0, blue: 125.0 / 255.0, alpha: 1)
let UCCPTActive = CPTColor.greenColor()
let UCCPTInitial = CPTColor.blueColor()
let UCCPTFinal = CPTColor.purpleColor()
let UCCPTAlternativeFinal = CPTColor.redColor()

let UCBlue = UIColor(red: 0.0 / 255.0, green: 40.0 / 255.0, blue: 130.0 / 255.0, alpha: 1)
let UCGreen = UIColor(red: 0.0 / 255.0, green: 135.0 / 255.0, blue: 137.0 / 255.0, alpha: 1)
let UCGreenAdditional = UIColor(red: 0.0 / 255.0, green: 183.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)
let UCGray = UIColor(red: 125.0 / 255.0, green: 125.0 / 255.0, blue: 125.0 / 255.0, alpha: 1)



enum UCChartType: String {
  case FormPie = "formPie"
  case FieldPie = "fieldPie"
  case StatePie = "statePie"
  case HistoryLines = "historyLines"
}

enum UCDescType: String {
  case Fulltime = "Fulltime"
  case Parttime = "Parttime"
  case Individual = "Individual"
}

enum UCDescField: String {
  case ICT = "ICT Project Management"
  case IT = "Information Technology"
  case EM = "Economics & Management"
}

enum UCLang: String {
  case All = "All"
  case Czech = "Czech"
  case English = "English"
}

enum UCPrimaryDataLanguage : String {
  case Czech = "čeština"
  case English = "angličtina"
}

enum UCPrimaryDataFormType: String {
  case Fulltime = "Prezenční studium"
  case Parttime = "Kombinované studium"
  case Individual = "Individuální studium"
}

enum UCPrimaryDataField : String {
  case ICT = "Management ICT projektů"
  case IT = "Informační technologie"
  case EM = "Ekonomika a management"
}