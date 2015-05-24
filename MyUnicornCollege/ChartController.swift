//
//  pieChartController.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 22.03.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit

class ChartController: UIViewController, CPTPlotDataSource, CPTPieChartDataSource {
  
  var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var pieChartData: [pieChartDataStruct] = []
  
  private var pieChartDataAll: [pieChartDataStruct] = []
  private var pieChartDataCZ: [pieChartDataStruct] = []
  private var pieChartDataEN: [pieChartDataStruct] = []
  
  private var pieChartDataCurrent: [pieChartDataStruct] = []
  

  @IBOutlet weak var graphView: CPTGraphHostingView!
  @IBOutlet weak var countLabel: UILabel!
  
  var itemIndex: Int = 0
  var chartType: String = ""
  var language: Int = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var model = appDelegate.applicationsModel
    var biModel = appDelegate.biModel

    if (model.data.count > 0)
    {
      pieChartData = biModel.loadDataForChart(model.data, chartType: chartType)
      
      //All
      for a in pieChartData {
        if a.lang == UCLang.LangAll {
          pieChartDataAll.append(a)
        }
      }

      //CZ
      for a in pieChartData {
        if a.lang == UCLang.LangCZ {
          pieChartDataCZ.append(a)
        }
      }

      //EN
      for a in pieChartData {
        if a.lang == UCLang.LangEN {
          pieChartDataEN.append(a)
        }
      }
    }
    
    // all
    
    var graph = CPTXYGraph(frame: CGRectZero)
    //graph.title = chartType
    graph.paddingLeft = 0
    graph.paddingTop = 0
    graph.paddingRight = 0
    graph.paddingBottom = 0
    
    // hide the axes
    var axes = graph?.axisSet as! CPTXYAxisSet
    var lineStyle = CPTMutableLineStyle()
    lineStyle.lineWidth = 0
    axes.xAxis.axisLineStyle = lineStyle
    axes.yAxis.axisLineStyle = lineStyle
    
    // add a pie plot
    var pie = CPTPieChart(frame: graph.frame)
    pie.dataSource = self
    pie.pieRadius = (self.view.frame.size.width * 0.9)/2
    pie.pieInnerRadius = (self.view.frame.size.width * 0.3)/2
    pie.identifier = chartType
    pie.startAngle = CGFloat(M_PI_4)
    pie.labelOffset = -50.0
    graph!.addPlot(pie)
    graph!.axisSet = nil
    graph!.borderLineStyle = nil
    
    self.graphView.hostedGraph = graph
    
    graph.reloadData()
    
  }
  
  private func getTotalPerLang(dataStruct: [pieChartDataStruct]) -> Int
  {
    var total: Int = 0
    
    for a in dataStruct {
      total += a.count
    }
    
    return total
  }
  
  func dataLabelForPlot(plot: CPTPlot!, recordIndex idx: UInt) -> CPTLayer! {
    var label: String = "\(pieChartDataCurrent[Int(idx)].category.rawValue)\n\(String(pieChartDataCurrent[Int(idx)].count))"
    
    let paragraphStyle =  NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.Center
    paragraphStyle.lineSpacing = 5
    
    let attrString = NSAttributedString(string:label, attributes:
      [NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont.boldSystemFontOfSize(14), NSParagraphStyleAttributeName: paragraphStyle])
    
    if pieChartDataCurrent[Int(idx)].count > 0 {
      return CPTTextLayer(attributedText: attrString)
    } else {
      return CPTTextLayer(text: "")
    }
  }
  
  func sliceFillForPieChart(pieChart: CPTPieChart!, recordIndex idx: UInt) -> CPTFill! {
    var areaColor : CPTColor = pieChartDataCurrent[Int(idx)].color
    var sliceFill : CPTFill = CPTFill(color: areaColor)
    
    return sliceFill
  }
  
  
  func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
    return UInt(pieChartDataCurrent.count)
  }
  
  func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject! {
    return pieChartDataCurrent[Int(idx)].count
  }
  
  
  func loadingPieChartDataCompleted(data: [pieChartDataStruct]) {
    println(data)
  }
  
  func loadingError(error: String) {
    println(error)
  }
  
  override func viewWillAppear(animated: Bool) {
    
    switch language {
    case 1:
      countLabel.text = String(getTotalPerLang(pieChartDataCZ))
      pieChartDataCurrent = pieChartDataCZ
      break
    case 2:
      countLabel.text = String(getTotalPerLang(pieChartDataEN))
      pieChartDataCurrent = pieChartDataEN
      break
    default:
      countLabel.text = String(getTotalPerLang(pieChartDataAll))
      pieChartDataCurrent = pieChartDataAll
      break
    }

    self.graphView.hostedGraph.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
