//
//  PageViewController.swift
//  MyUnicornCollege
//
//  Created by Marek Beranek on 27.02.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
  var applicationsTableVC: ViewController?
  var statsVC: StatsViewController?
  var pageControl: UIPageControl?
  var appsData: [ApplicationItem] = []

  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.delegate = self
      self.dataSource = self
        
      applicationsTableVC = self.storyboard?.instantiateViewControllerWithIdentifier("applicationsTable") as? ViewController
      statsVC = self.storyboard?.instantiateViewControllerWithIdentifier("statsController") as? StatsViewController
      var viewControllers = NSArray(objects: applicationsTableVC!)
      self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
      
      self.pageControl = UIPageControl(frame: CGRectMake(100, 100, 100, 100))
      self.pageControl?.setTranslatesAutoresizingMaskIntoConstraints(false)
      
      self.pageControl?.currentPageIndicatorTintColor = UIColor.darkGrayColor()
      self.pageControl?.pageIndicatorTintColor = UIColor.lightGrayColor()
      self.pageControl?.numberOfPages = 2
      self.pageControl?.currentPage = 0
      self.view.addSubview(self.pageControl!)

      // constraints definition
      var centerConstraint = NSLayoutConstraint(item: self.pageControl!, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
      var bottomConstraint = NSLayoutConstraint(item: self.pageControl!, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)

      self.view.addConstraint(centerConstraint)
      self.view.addConstraint(bottomConstraint)
      
      self.view.bringSubviewToFront(self.pageControl!)
      
      // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
  
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
      return 2
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
      if (viewController == self.applicationsTableVC) {
        return self.statsVC
      } else {
        return self.applicationsTableVC
      }
    }
  
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
      if(viewController == self.applicationsTableVC){
        return self.statsVC
      }else{
        return self.applicationsTableVC
      }
    }
  
  func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
    if(pendingViewControllers.first as? ViewController == self.applicationsTableVC){
      self.pageControl?.currentPage = 0
    } else {
      self.pageControl?.currentPage = 1
    }
  }
}
