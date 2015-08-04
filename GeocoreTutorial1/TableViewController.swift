//
//  TableViewController.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 7/31/15.
//  Copyright (c) 2015 MapMotion. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
        
    var textLabel: UITableView?
    var detailTextLabel: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.sharedInstance.places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let place = DataSource.sharedInstance.places[indexPath.row]
        
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = place.subtitle
        
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailsFromList" {
            
            var detailsVC: DetailsViewController = segue.destinationViewController as! DetailsViewController
            
            let tableIndex = tableView.indexPathForSelectedRow()?.row
            let place = DataSource.sharedInstance.places[tableIndex!]
            detailsVC.place = place
            
        }
        
    }
}
