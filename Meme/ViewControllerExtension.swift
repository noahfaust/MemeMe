//
//  ViewControllerExtension.swift
//  Meme
//
//  Created by Alexandre Gonzalo on 11/11/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func getMemeTextAttributes(size: CGFloat) -> [String: AnyObject] {
        return [
            NSFontAttributeName : UIFont(name: "Impact", size: size)!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -2.0
        ]
    }
    
    func pushDetailViewController(indexPath: NSIndexPath) {
        //Grab the DetailVC from Storyboard
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
    
        //Populate view controller with data from the selected item
        detailViewController.meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.item]
    
        //Present the view controller using navigation
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
}
