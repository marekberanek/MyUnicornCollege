//
//  LoginViewController.swift
//  MyUnicornCollege
//
//  Created by Marek Beránek on 20.06.15.
//  Copyright (c) 2015 Marek Beránek. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

  @IBOutlet weak var accessCodeOne: UITextField!
  @IBOutlet weak var accessCodeTwo: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
  
  var defaultTextFiledColor : UIColor = UIColor.blackColor()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.accessCodeOne.hidden = true
    self.accessCodeTwo.hidden = true
    self.loginButton.hidden = true
    
    verifyUserCredentials(p4u_user!, password: p4u_password!, callback: {
      self.progressIndicator.hidden = true
      self.progressIndicator.stopAnimating()
      
      // If user is logged, go directly to proper view controller
      if p4u_logged == "1" {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UITabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
        
        println("logged")
        
      } else {
        self.defaultTextFiledColor = self.accessCodeOne.textColor
        self.progressIndicator.hidden = true

        self.accessCodeOne.hidden = false
        self.accessCodeTwo.hidden = false
        self.loginButton.hidden = false
      
      }
    })
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  

  @IBAction func accessCodeOneEditingBegin(sender: AnyObject) {
    if accessCodeOne.text == UCDefaultACValue.ACOne.rawValue {
      accessCodeOne.text = ""
      accessCodeOne.textColor = UIColor.blackColor()
      accessCodeOne.secureTextEntry = true
    }
  }
  
  @IBAction func accessCodeOneEditingEnd(sender: AnyObject) {
    if accessCodeOne.text == "" {
      accessCodeOne.text = UCDefaultACValue.ACOne.rawValue
      accessCodeOne.textColor = defaultTextFiledColor
      accessCodeOne.secureTextEntry = false
    }
  }
  @IBAction func accessCodeOneDidEndOnExit(sender: AnyObject) {
    defaults.setValue(accessCodeOne.text, forKey: "access_code1")
  }
  
  @IBAction func accessCodeTwoEditingBegin(sender: AnyObject) {
    if accessCodeTwo.text == UCDefaultACValue.ACTwo.rawValue {
      accessCodeTwo.text = ""
      accessCodeTwo.textColor = UIColor.blackColor()
      accessCodeTwo.secureTextEntry = true
    }
  }
  
  @IBAction func accessCodeTwoEditingEnd(sender: AnyObject) {
    if accessCodeTwo.text == "" {
      accessCodeTwo.text = UCDefaultACValue.ACTwo.rawValue
      accessCodeTwo.textColor = defaultTextFiledColor
      accessCodeTwo.secureTextEntry = false
    }
  }
  
  @IBAction func loginButtonTouchDown(sender: AnyObject) {
    verifyUserCredentials(accessCodeOne.text, password: accessCodeTwo.text, callback: {
      self.progressIndicator.hidden = true
      self.progressIndicator.stopAnimating()

      let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
      let vc : UITabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
      
      var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      appDelegate.window?.rootViewController = vc
    })
  }
  
  func verifyUserCredentials(user: String, password: String, callback: () -> ()) {
    var url = "https://api.plus4u.net/ues/wcp/ues/core/artifact/UESArtifact/getAttributes?uesuri=ues:UCL-BT:SGC.EPR/1516"
    
    progressIndicator.hidden = false
    progressIndicator.startAnimating()
    
    Alamofire.request(.GET, url)
      .authenticate(user: user, password: password)
      .responseJSON() {
        (_, response, _, _) in

        defaults.setValue(user, forKey: "access_code1")
        defaults.setValue(password, forKey: "access_code2")
        p4u_user = user
        p4u_password = password
        
        
        
        if response?.statusCode == 200 {
          defaults.setValue("1", forKey: "logged")
          p4u_logged = "1"
        } else {
          defaults.setValue("0", forKey: "logged")
          p4u_logged = "0"
        }
        
        callback()
    }
  }
}
