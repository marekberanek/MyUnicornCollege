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
        if a.lang == UCLang.All {
          pieChartDataAll.append(a)
        }
      }

      //CZ
      for a in pieChartData {
        if a.lang == UCLang.Czech {
          pieChartDataCZ.append(a)
        }
      }

      //EN
      for a in pieChartData {
        if a.lang == UCLang.English {
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
    
    var labelOffset: CGFloat = -70
    
    
    // add a pie plot
    var pie = CPTPieChart(frame: graph.frame)
    pie.dataSource = self
    pie.pieRadius = (self.view.frame.size.width * 0.9)/2
    pie.pieInnerRadius = (self.view.frame.size.width * 0.3)/2

    // count a label offset
    labelOffset = (pie.pieRadius - pie.pieInnerRadius) * -2/3

    pie.identifier = chartType
    pie.startAngle = CGFloat(M_PI_4)
    pie.labelOffset = labelOffset
    pie.sliceDirection = CPTPieDirection.Clockwise
    graph!.addPlot(pie)
    graph!.axisSet = nil
    graph!.borderLineStyle = nil

    var legend = CPTLegend(graph: graph)
    
    switch chartType {
      case UCChartType.FieldPie.rawValue:
        legend.numberOfColumns = 2
        break
    default:
      legend.numberOfColumns = 2
      break
    }
    
    legend.fill = CPTFill(color: CPTColor.whiteColor())
    graph.legend = legend
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
    let dataPercentage: Float = 100*Float(pieChartDataCurrent[Int(idx)].count) / Float(getTotalPerLang(pieChartDataCurrent))
    let dataRaw: Int = pieChartDataCurrent[Int(idx)].count
    
    var label: String = "\(Int(dataRaw))"
    
    let paragraphStyle =  NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.Center
    paragraphStyle.lineSpacing = 5
    
    let shadow = NSShadow()
    shadow.shadowColor = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 0.4)
    shadow.shadowOffset = CGSizeMake(-1.0, -1.0)
    shadow.shadowBlurRadius = 1
    
    let attrString = NSAttributedString(string:label, attributes:
      [NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont.boldSystemFontOfSize(20), NSParagraphStyleAttributeName: paragraphStyle, NSShadowAttributeName: shadow])
    
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
  
  func legendTitleForPieChart(pieChart: CPTPieChart!, recordIndex idx: UInt) -> String! {
    return pieChartDataCurrent[Int(idx)].category
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    reloadGraph()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func reloadGraph() {
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
