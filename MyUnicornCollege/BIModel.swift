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
  
  func loadDataForChart(data: [ApplicationItem], chartType: UCChartType) -> [pieChartDataStruct]
  {
    var formPieChartData: [pieChartDataStruct]

    formPieChartData = []

    if (chartType == .FormPie) {
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
    dataForChart.append(pieChartDataStruct(category: .FormFT , lang: descLangAll, count: tempFilteredData.count))
    
    // Fulltime and all languages
    tempFilteredData = data.filter { a in a.type == typePT }
    dataForChart.append(pieChartDataStruct(category: .FormPT, lang: descLangAll, count: tempFilteredData.count))
    
    // Partime and czech language
    tempFilteredData = data.filter { a in a.type == typeFT && a.language == langCZ }
    dataForChart.append(pieChartDataStruct(category: .FormFT, lang: descLangCZ, count: tempFilteredData.count))
    
    // Parttime and czech language
    tempFilteredData = data.filter { a in a.type == typePT && a.language == langCZ }
    dataForChart.append(pieChartDataStruct(category: .FormPT, lang: descLangCZ, count: tempFilteredData.count))
    
    // Partime and english language
    tempFilteredData = data.filter { a in a.type == typeFT && a.language == langEN }
    dataForChart.append(pieChartDataStruct(category: .FormFT, lang: descLangEN, count: tempFilteredData.count))
    
    // Parttime and english language
    tempFilteredData = data.filter { a in a.type == typePT && a.language == langEN }
    dataForChart.append(pieChartDataStruct(category: .FormPT, lang: descLangEN, count: tempFilteredData.count))
    
    return dataForChart
    
  }
}
