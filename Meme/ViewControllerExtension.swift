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
        detailViewController.indexPath = indexPath
    
        //Present the view controller using navigation
        navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    func presentEditorWithMeme(meme: Meme) {
        let editorViewController = storyboard?.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        editorViewController.meme = meme
        presentViewController(editorViewController, animated: true, completion: nil)
    }
    
    func deleteMeme(indexPath: NSIndexPath) {
        // Get the App Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        // Delete the meme from the app delegate
        appDelegate.deleteMeme(indexPath)
    }
}
