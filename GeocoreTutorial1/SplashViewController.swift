//
//  ViewController.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 7/27/15.
//  Copyright (c) 2015 MapMotion. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var timer = NSTimer()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("segueTrigger"), userInfo: nil, repeats: false)
        
    }
    
    func segueTrigger() {
        performSegueWithIdentifier("splashScreenToTabBar", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

