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
  
  private var chartTypes = ["formPie", "fieldPie", "statesBars", "historyLines"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createPageViewController()
  }
  
  private func createPageViewController() {
    let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("pageViewController") as UIPageViewController
    pageController.dataSource = self
    
    if (chartTypes.count > 0)
    {
      let firstController = getItemController(0)!
      let startingViewController: NSArray = [firstController]
      pageController.setViewControllers(startingViewController, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    pageViewController = pageController
    addChildViewController(pageViewController!)
    self.view.addSubview(pageViewController!.view)
    pageViewController!.didMoveToParentViewController(self)
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let itemController = viewController as ChartController
    
    if itemController.itemIndex > 0 {
      return getItemController(itemController.itemIndex-1)
    }
    
    return nil
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let itemController = viewController as ChartController
    
    if itemController.itemIndex+1 < chartTypes.count {
      return getItemController(itemController.itemIndex+1)
    }
    
    return nil
  }
  
  private func getItemController(itemIndex: Int) -> ChartController? {
    if itemIndex < chartTypes.count {
      let chartController = self.storyboard!.instantiateViewControllerWithIdentifier("chartController") as ChartController
      chartController.itemIndex = itemIndex
      chartController.chartType = chartTypes[itemIndex]
      return chartController
    }
    return nil
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return chartTypes.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

    
}
