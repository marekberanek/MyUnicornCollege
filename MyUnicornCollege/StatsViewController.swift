//
//  StatsViewController.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 28.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UIPageViewControllerDataSource {

  private var pageViewController: UIPageViewController?
  
  private var formChartController: ChartController?
  private var fieldChartController: ChartController?
  private var stateChartController: ChartController?
  @IBOutlet weak var segmentControl: UISegmentedControl!
  
  private var chartTypes = ["formPie", "fieldPie", "statesBars", "historyLines"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formChartController = self.storyboard!.instantiateViewControllerWithIdentifier("chartController") as? ChartController
    formChartController?.itemIndex = 0
    formChartController?.language = segmentControl.selectedSegmentIndex
    formChartController?.chartType = "formPie"

    fieldChartController = self.storyboard!.instantiateViewControllerWithIdentifier("chartController") as? ChartController
    fieldChartController?.itemIndex = 0
    fieldChartController?.language = segmentControl.selectedSegmentIndex
    fieldChartController?.chartType = "fieldPie"

    stateChartController = self.storyboard!.instantiateViewControllerWithIdentifier("chartController") as? ChartController
    stateChartController?.itemIndex = 0
    stateChartController?.language = segmentControl.selectedSegmentIndex
    stateChartController?.chartType = "statePie"
    
    let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("pageViewController") as! UIPageViewController
    pageController.dataSource = self
    
    let firstController = formChartController
    let startingViewControler: [ChartController] = [firstController!]
    
    pageController.setViewControllers(startingViewControler as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    
    pageViewController = pageController
    addChildViewController(pageViewController!)
    self.view.addSubview(pageViewController!.view)
    pageViewController!.didMoveToParentViewController(self)
  }
  
  @IBAction func indexChanged(sender: AnyObject) {
    
    println(sender.selectedSegmentIndex)
    var chartController : ChartController?
    
    chartController = pageViewController?.viewControllers[0] as? ChartController
    
    if chartController == formChartController {
      
      formChartController?.language = sender.selectedSegmentIndex
    } else if chartController == fieldChartController {
      fieldChartController?.language = sender.selectedSegmentIndex
    } else if chartController == stateChartController {
      stateChartController?.language = sender.selectedSegmentIndex
    }

  }
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

    var properViewController: UIViewController = UIViewController()
    
    if viewController == formChartController {
      properViewController = fieldChartController! } else if
      viewController == fieldChartController {
        properViewController = stateChartController!
    } else if viewController == stateChartController {
      properViewController = formChartController!
    }
    
    return properViewController
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    var properViewController: UIViewController = UIViewController()
    
    if viewController == stateChartController {
      properViewController = fieldChartController! }
    else if viewController == fieldChartController {
        properViewController = formChartController!
    } else if viewController == formChartController {
      properViewController = stateChartController!
    }
    
    return properViewController
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 3
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

    
}
