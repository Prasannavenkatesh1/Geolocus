//
//  RightViewController.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class RightViewController: UIViewController {

    @IBOutlet var menuTableView: UITableView!
    

    
}


//Code for Delegates and Data Source
extension RightViewController {
    
func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayConstants.MenuList.count
    }
    
  
    
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = StringConstants.MenuCellIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.textLabel?.text = ArrayConstants.MenuList[indexPath.row]
        cell.textLabel?.textAlignment = .Center
        return cell
        
    }
    
}