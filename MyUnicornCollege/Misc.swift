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
var p4u_user : String? = defaults.stringForKey("access_code1")
var p4u_password : String? = defaults.stringForKey("access_code2")
var p4u_logged : String? = defaults.stringForKey("logged")
var p4u_autologin : Bool? = defaults.boolForKey("autologin")


//let UCBlue = UIColor(red: , green: , blue: , alpha: 1)
let UCCPTBlue = CPTColor(componentRed: 0.0 / 255.0, green: 40.0 / 255.0, blue: 130.0 / 255.0, alpha: 1)
let UCCPTGreen = CPTColor(componentRed: 0.0 / 255.0, green: 135.0 / 255.0, blue: 137.0 / 255.0, alpha: 1)
let UCCPTGreenAdditional = CPTColor(componentRed: 0.0 / 255.0, green: 183.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)
let UCCPTGray = CPTColor(componentRed: 125.0 / 255.0, green: 125.0 / 255.0, blue: 125.0 / 255.0, alpha: 1)
let UCCPTActive = CPTColor(componentRed: 89.0 / 255.0, green: 227.0 / 255.0, blue: 48.0 / 255.0, alpha: 1)
let UCCPTInitial = CPTColor(componentRed: 52.0 / 255.0, green: 226.0 / 255.0, blue: 239.0 / 255.0, alpha: 1)
let UCCPTFinal = CPTColor(componentRed: 114.0 / 255.0, green: 177.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
let UCCPTAlternativeFinal = CPTColor(componentRed: 255.0 / 255.0, green: 162.0 / 255.0, blue: 193.0 / 255.0, alpha: 1)

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

enum UCApplicationState : String {
  case Initial = "INITIAL"
  case Active = "ACTIVE"
  case Final = "Přijat ke studiu"
  case AlternativeFinal = "ALTERNATIVE_FINAL"
}

enum UCDescApplicationState : String {
  case Initial = "Created"
  case Active = "Waiting for interview"
  case Final = "Accepted"
  case AlternativeFinal = "Not Accepted"
}

enum UCDefaultACValue : String {
  case ACOne = "Access Code 1"
  case ACTwo = "Access Code 2"
}