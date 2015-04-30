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
  

  @IBOutlet weak var graphView: CPTGraphHostingView!
  @IBOutlet weak var countLabel: UILabel!
  
  var itemIndex: Int = 0
  var chartType: String = ""
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var graph = CPTXYGraph(frame: CGRectZero)
    //graph.title = chartType
    graph.paddingLeft = 0
    graph.paddingTop = 0
    graph.paddingRight = 0
    graph.paddingBottom = 0
    
    // hide the axes
    var axes = graph.axisSet as! CPTXYAxisSet
    var lineStyle = CPTMutableLineStyle()
    lineStyle.lineWidth = 0
    axes.xAxis.axisLineStyle = lineStyle
    axes.yAxis.axisLineStyle = lineStyle
    
    // add a pie plot
    var pie = CPTPieChart()
    pie.dataSource = self
    pie.pieRadius = (self.view.frame.size.width * 0.9)/2
    pie.pieInnerRadius = (self.view.frame.size.width * 0.4)/2
    pie.identifier = chartType
    pie.startAngle = CGFloat(M_PI_4)
    pie.labelOffset = -50.0
    graph.addPlot(pie)
    graph.axisSet = nil
    graph.borderLineStyle = nil
    
    self.graphView.hostedGraph = graph
    
    graph.reloadData()
    
    /*    var theLegend : CPTLegend = CPTLegend(graph: graph)
    theLegend.numberOfColumns = 2
    graph.legend = theLegend
    graph.legendAnchor = CPTRectAnchorBottom
    graph.legendDisplacement = CGPointMake(0.0, 20.0)
    */
    
  }
  
  func dataLabelForPlot(plot: CPTPlot!, recordIndex idx: UInt) -> CPTLayer! {
    var label : String = ""
    switch (idx)
    {
    case 0:
      label = "AAA"
      break
    case 1:
      label = "EEE"
      break
    case 2:
      label = "CCC"
      break
    default:
      label = ""
      break
    }
    return CPTTextLayer(text: label)
  }
  
  func sliceFillForPieChart(pieChart: CPTPieChart!, recordIndex idx: UInt) -> CPTFill! {
    
    var areaColor : CPTColor
    
    switch (idx) {
      
    case 0:
      areaColor = CPTColor.redColor()
      break
    case 1:
      areaColor = CPTColor.blueColor()
      break
    case 2:
      areaColor = CPTColor.brownColor()
      break
    case 3:
      areaColor = CPTColor.yellowColor()
      break
    default:
      areaColor = CPTColor.purpleColor()
      break
    }
    
    var sliceFill : CPTFill = CPTFill(color: areaColor)
    
    return sliceFill
  }
  
  func legendTitleForPieChart(pieChart: CPTPieChart!, recordIndex idx: UInt) -> String! {
    if idx==1 {return "ahoj"} else {return "ddd"}
  }
  
  func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
    if chartType == "formPie" { return 4 } else {return 3}
  }
  
  func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> NSNumber! {
    println(fieldEnum)
    return idx+1
  }
  
  
  func loadingPieChartDataCompleted(data: [pieChartDataStruct]) {
    println(data)
  }
  
  func loadingError(error: String) {
    println(error)
  }
  
  override func viewDidAppear(animated: Bool) {
    var model = appDelegate.applicationsModel
    var biModel = appDelegate.biModel
    
/*
    if (model.data.count > 0) {
      biModel.loadDataForChart(model.data, chartType: UCChartType.FormPie)
    }
    
    */
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
