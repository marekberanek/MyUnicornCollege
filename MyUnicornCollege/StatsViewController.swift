//
//  StatsViewController.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 28.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

  private var pageViewController: UIPageViewController?
  
  private var formChartController: ChartController?
  private var fieldChartController: ChartController?
  private var stateChartController: ChartController?
  @IBOutlet weak var segmentControl: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formChartController = self.storyboard!.instantiateViewControllerWithIdentifier("chartController") as? ChartController
    formChartController?.language = segmentControl.selectedSegmentIndex
    formChartController?.chartType = UCChartType.FormPie.rawValue

    fieldChartController = self.storyboard!.instantiateViewControllerWithIdentifier("chartController") as? ChartController
    fieldChartController?.language = segmentControl.selectedSegmentIndex
    fieldChartController?.chartType = UCChartType.FieldPie.rawValue

    stateChartController = self.storyboard!.instantiateViewControllerWithIdentifier("chartController") as? ChartController
    stateChartController?.language = segmentControl.selectedSegmentIndex
    stateChartController?.chartType = UCChartType.StatePie.rawValue
    
    let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("pageViewController") as! UIPageViewController
    pageController.dataSource = self
    pageController.delegate = self
    
    let firstController = formChartController
    let startingViewControler: [ChartController] = [firstController!]
    
    pageController.setViewControllers(startingViewControler as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    
    pageViewController = pageController
    addChildViewController(pageViewController!)
    self.view.addSubview(pageViewController!.view)
    pageViewController!.didMoveToParentViewController(self)
  }
  
  // Reload chart according to selected language
  @IBAction func indexChanged(sender: AnyObject) {
    
    var chartController: ChartController? = pageViewController?.viewControllers[0] as? ChartController
    
    if chartController == formChartController {
      formChartController?.language = sender.selectedSegmentIndex
      formChartController?.reloadGraph()
    } else if chartController == fieldChartController {
      fieldChartController?.language = sender.selectedSegmentIndex
      fieldChartController?.reloadGraph()
    } else if chartController == stateChartController {
      stateChartController?.language = sender.selectedSegmentIndex
      stateChartController?.reloadGraph()
    }

  }
  
  // Set proper selected segment index
  func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
    segmentControl.selectedSegmentIndex = pendingViewControllers.first!.language
  }
  
  // Backward navigation
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

    var properViewController: UIViewController = UIViewController()
    
    if viewController == formChartController {
      properViewController = stateChartController!
    } else if viewController == fieldChartController {
      properViewController = formChartController!
    } else if viewController == stateChartController {
      properViewController = fieldChartController!
    }
    
    return properViewController
  }
  
  // Forward navigation
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    var properViewController: UIViewController = UIViewController()
    
    if viewController == fieldChartController {
      properViewController = stateChartController!
    } else if viewController == formChartController {
      properViewController = fieldChartController!
    } else if viewController == stateChartController {
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
