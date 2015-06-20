//
//  BIModel.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 20.03.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import Foundation

class BIModel: NSObject {
  
  override init() {
    super.init()
  }
  
  func loadDataForChart(data: [DBApplicationItem], chartType: String) -> [pieChartDataStruct]
  {
    var formPieChartData: [pieChartDataStruct]

    formPieChartData = []
    
    switch chartType
    {
      case "formPie":
        formPieChartData = prepareDataForFormPieChart(data)
        break
      case "fieldPie" :
        formPieChartData = prepareDataForFieldPieChart(data)
        break
    case "statePie" :
      formPieChartData = prepareDataForStatePieChart(data)
      break
    default:
        break
    }
    
    return formPieChartData
  }
  
  
  // preparing data for form pie chart
  private func prepareDataForFormPieChart(data: [DBApplicationItem]) -> [pieChartDataStruct]
  {
    var dataForChart : [pieChartDataStruct] = []
    
    var tempFilteredData : [DBApplicationItem] = []
    
    /*
      Applicants for study without language differentiation
    */
    
    // Fulltime and all languages
    tempFilteredData = data.filter { a in a.type == UCPrimaryDataFormType.Fulltime.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescType.Fulltime.rawValue , lang: .All, count: tempFilteredData.count, color: UCCPTBlue))
    }
    
    // Parttime and all languages
    tempFilteredData = data.filter { a in a.type == UCPrimaryDataFormType.Parttime.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescType.Parttime.rawValue, lang: .All, count: tempFilteredData.count, color: UCCPTGreen))
    }
    
    // Individual and all languages
    tempFilteredData = data.filter { a in a.type == UCPrimaryDataFormType.Individual.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescType.Individual.rawValue, lang: .All, count: tempFilteredData.count, color: UCCPTGreenAdditional))
    }

    /*
      Applicants for study in Czech
    */

    // Partime and czech language
    tempFilteredData = data.filter { a in a.type == UCPrimaryDataFormType.Fulltime.rawValue && a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescType.Fulltime.rawValue, lang: .Czech, count: tempFilteredData.count, color: UCCPTBlue))
    }
    
    // Parttime and czech language
    tempFilteredData = data.filter { a in a.type == UCPrimaryDataFormType.Parttime.rawValue && a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescType.Parttime.rawValue, lang: .Czech, count: tempFilteredData.count, color: UCCPTGreen))
    }

    // Individual and czech language
    tempFilteredData = data.filter { a in a.type == UCPrimaryDataFormType.Individual.rawValue && a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescType.Individual.rawValue, lang: .Czech, count: tempFilteredData.count, color: UCCPTGreenAdditional))
    }
    
    /*
      Applicants for study in English
    */
    
    // Partime and english language
    tempFilteredData = data.filter { a in a.type == UCPrimaryDataFormType.Fulltime.rawValue && a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescType.Fulltime.rawValue, lang: .English, count: tempFilteredData.count, color: UCCPTBlue))
    }
    
    // Parttime and english language
    tempFilteredData = data.filter { a in a.type == UCPrimaryDataFormType.Parttime.rawValue && a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescType.Parttime.rawValue, lang: .English, count: tempFilteredData.count, color: UCCPTGreen))
    }

    // Individual and english language
    tempFilteredData = data.filter { a in a.type == UCPrimaryDataFormType.Individual.rawValue && a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescType.Individual.rawValue, lang: .English, count: tempFilteredData.count, color: UCCPTGreenAdditional))
    }

    return dataForChart
    
  }
  
  // preparing data for field pie chart
  private func prepareDataForFieldPieChart(data: [DBApplicationItem]) -> [pieChartDataStruct]
  {
    var dataForChart : [pieChartDataStruct] = []
    
    var tempFilteredData : [DBApplicationItem] = []
    
    /*
    Applicants for study without language differentiation
    */
    
    // ICT Project Management
    tempFilteredData = data.filter { a in a.field == UCPrimaryDataField.ICT.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescField.ICT.rawValue , lang: .All, count: tempFilteredData.count, color: UCCPTBlue))
    }
    
    // Information Technology
    tempFilteredData = data.filter { a in a.field == UCPrimaryDataField.IT.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescField.IT.rawValue, lang: .All, count: tempFilteredData.count, color: UCCPTGreen))
    }
    
    // Economics & Management
    tempFilteredData = data.filter { a in a.field == UCPrimaryDataField.EM.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescField.EM.rawValue, lang: .All, count: tempFilteredData.count, color: UCCPTGreenAdditional))
    }

    /*
    Applicants for study in Czech
    */
    
    // ICT Project Management
    tempFilteredData = data.filter { a in a.field == UCPrimaryDataField.ICT.rawValue &&  a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescField.ICT.rawValue , lang: .Czech, count: tempFilteredData.count, color: UCCPTBlue))
    }
    
    // Information Technology
    tempFilteredData = data.filter { a in a.field == UCPrimaryDataField.IT.rawValue &&  a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescField.IT.rawValue, lang: .Czech, count: tempFilteredData.count, color: UCCPTGreen))
    }
    
    // Economics & Management
    tempFilteredData = data.filter { a in a.field == UCPrimaryDataField.EM.rawValue &&  a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescField.EM.rawValue, lang: .Czech, count: tempFilteredData.count, color: UCCPTGreenAdditional))
    }

    /*
    Applicants for study in English
    */
    
    // ICT Project Management
    tempFilteredData = data.filter { a in a.field == UCPrimaryDataField.ICT.rawValue &&  a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescField.ICT.rawValue , lang: .English, count: tempFilteredData.count, color: UCCPTBlue))
    }
    
    // Information Technology
    tempFilteredData = data.filter { a in a.field == UCPrimaryDataField.IT.rawValue &&  a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescField.IT.rawValue, lang: .English, count: tempFilteredData.count, color: UCCPTGreen))
    }
    
    // Economics & Management
    tempFilteredData = data.filter { a in a.field == UCPrimaryDataField.EM.rawValue &&  a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescField.EM.rawValue, lang: .English, count: tempFilteredData.count, color: UCCPTGreenAdditional))
    }

    return dataForChart
  }
  
  // preparing data for field pie chart
  private func prepareDataForStatePieChart(data: [DBApplicationItem]) -> [pieChartDataStruct]
  {
    var dataForChart : [pieChartDataStruct] = []
    
    var tempFilteredData : [DBApplicationItem] = []
    
    /*
    Applicants for study without language differentiation
    */
    
    // Initial
    tempFilteredData = data.filter { a in a.stateType == UCApplicationState.Initial.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.Initial.rawValue , lang: .All, count: tempFilteredData.count, color: UCCPTInitial))
    }
    
    // Active
    tempFilteredData = data.filter { a in a.stateType == UCApplicationState.Active.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.Active.rawValue , lang: .All, count: tempFilteredData.count, color: UCCPTActive))
    }
    
    // Final
    tempFilteredData = data.filter { a in a.state == UCApplicationState.Final.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.Final.rawValue , lang: .All, count: tempFilteredData.count, color: UCCPTFinal))
    }

    // Alternative Final
    tempFilteredData = data.filter { a in a.stateType == UCApplicationState.AlternativeFinal.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.AlternativeFinal.rawValue , lang: .All, count: tempFilteredData.count, color: UCCPTAlternativeFinal))
    }

    /*
    Applicants for study in Czech
    */

    
    // Initial=
    tempFilteredData = data.filter { a in a.stateType == UCApplicationState.Initial.rawValue && a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.Initial.rawValue , lang: .Czech, count: tempFilteredData.count, color: UCCPTInitial))
    }
    
    // Active
    tempFilteredData = data.filter { a in a.stateType == UCApplicationState.Active.rawValue && a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.Active.rawValue , lang: .Czech, count: tempFilteredData.count, color: UCCPTActive))
    }
    
    // Final
    tempFilteredData = data.filter { a in a.state == UCApplicationState.Final.rawValue && a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.Final.rawValue , lang: .Czech, count: tempFilteredData.count, color: UCCPTFinal))
    }
    
    // Alternative Final
    tempFilteredData = data.filter { a in a.stateType == UCApplicationState.AlternativeFinal.rawValue && a.language == UCPrimaryDataLanguage.Czech.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.AlternativeFinal.rawValue , lang: .Czech, count: tempFilteredData.count, color: UCCPTAlternativeFinal))
    }

    /*
    Applicants for study in English
    */
    
    // Initial
    tempFilteredData = data.filter { a in a.stateType == UCApplicationState.Initial.rawValue && a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.Initial.rawValue , lang: .English, count: tempFilteredData.count, color: UCCPTInitial))
    }
    
    // Active
    tempFilteredData = data.filter { a in a.stateType == UCApplicationState.Active.rawValue && a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.Active.rawValue , lang: .English, count: tempFilteredData.count, color: UCCPTActive))
    }
    
    // Final
    tempFilteredData = data.filter { a in a.state == UCApplicationState.Final.rawValue && a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.Final.rawValue , lang: .English, count: tempFilteredData.count, color: UCCPTFinal))
    }
    
    // Alternative Final
    tempFilteredData = data.filter { a in a.stateType == UCApplicationState.AlternativeFinal.rawValue && a.language == UCPrimaryDataLanguage.English.rawValue }
    if (tempFilteredData.count > 0) {
      dataForChart.append(pieChartDataStruct(category: UCDescApplicationState.AlternativeFinal.rawValue , lang: .English, count: tempFilteredData.count, color: UCCPTAlternativeFinal))
    }
    
    return dataForChart
    
  }

  
}
