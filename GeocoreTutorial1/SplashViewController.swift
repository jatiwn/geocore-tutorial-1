//
//  ViewController.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 7/27/15.
//  Copyright (c) 2015 MapMotion. All rights reserved.
//

import UIKit
import GeocoreKit

class SplashViewController: UIViewController {
    
    var timer = NSTimer()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        
        Geocore.sharedInstance.loginWithDefaultUser().then { accessToken -> Void in
            self.segueTrigger()
            println("Logged in to Geocore successfully, with access token = \(accessToken)")
        }
        
    }
    
    func segueTrigger() {
        performSegueWithIdentifier("splashScreenToTabBar", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

