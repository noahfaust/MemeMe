//
//  TableViewController.swift
//  Meme
//
//  Created by Alexandre Gonzalo on 10/11/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell")!
        cell.textLabel!.text = memes[indexPath.row].topText
        cell.detailTextLabel?.text = memes[indexPath.row].bottomText
        cell.imageView!.image = memes[indexPath.row].image
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[indexPath.item]
        
        //Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
