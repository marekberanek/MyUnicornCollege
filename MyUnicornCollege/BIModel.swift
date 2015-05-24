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
  
  func loadDataForChart(data: [ApplicationItem], chartType: String) -> [pieChartDataStruct]
  {
    var formPieChartData: [pieChartDataStruct]

    formPieChartData = []

    if (chartType == "formPie") {
      formPieChartData = prepareDataForFormPieChart(data)
    }
    
    return formPieChartData
  }
  
  private func prepareDataForFormPieChart(data: [ApplicationItem]) -> [pieChartDataStruct]
  {
    var dataForChart : [pieChartDataStruct] = []
    
    var tempFilteredData : [ApplicationItem] = []
    
    // Fulltime and all languages
    tempFilteredData = data.filter { a in a.type == typeFT }
    dataForChart.append(pieChartDataStruct(category: .FormFT , lang: .LangAll, count: tempFilteredData.count, color: UCCPTBlue))
    
    // Parttime and all languages
    tempFilteredData = data.filter { a in a.type == typePT }
    dataForChart.append(pieChartDataStruct(category: .FormPT, lang: .LangAll, count: tempFilteredData.count, color: UCCPTGreen))

    // Individual and all languages
    tempFilteredData = data.filter { a in a.type == typeIN }
    dataForChart.append(pieChartDataStruct(category: .FormPT, lang: .LangAll, count: tempFilteredData.count, color: UCCPTGreenAdditional))

    // Partime and czech language
    tempFilteredData = data.filter { a in a.type == typeFT && a.language == langCZ }
    dataForChart.append(pieChartDataStruct(category: .FormFT, lang: .LangCZ, count: tempFilteredData.count, color: UCCPTBlue))
    
    // Parttime and czech language
    tempFilteredData = data.filter { a in a.type == typePT && a.language == langCZ }
    dataForChart.append(pieChartDataStruct(category: .FormPT, lang: .LangCZ, count: tempFilteredData.count, color: UCCPTGreen))

    // Individual and czech language
    tempFilteredData = data.filter { a in a.type == typeIN && a.language == langCZ }
    dataForChart.append(pieChartDataStruct(category: .FormIN, lang: .LangCZ, count: tempFilteredData.count, color: UCCPTGreenAdditional))

    // Partime and english language
    tempFilteredData = data.filter { a in a.type == typeFT && a.language == langEN }
    dataForChart.append(pieChartDataStruct(category: .FormFT, lang: .LangEN, count: tempFilteredData.count, color: UCCPTBlue))
    
    // Parttime and english language
    tempFilteredData = data.filter { a in a.type == typePT && a.language == langEN }
    dataForChart.append(pieChartDataStruct(category: .FormPT, lang: .LangEN, count: tempFilteredData.count, color: UCCPTGreen))

    // Individual and english language
    tempFilteredData = data.filter { a in a.type == typeIN && a.language == langEN }
    dataForChart.append(pieChartDataStruct(category: .FormIN, lang: .LangEN, count: tempFilteredData.count, color: UCCPTGreenAdditional))

    return dataForChart
    
  }
}
