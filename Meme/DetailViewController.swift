//
//  DetailViewController.swift
//  Meme
//
//  Created by Alexandre Gonzalo on 10/11/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme!
    var indexPath:NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an Edit button
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme")

        // Create a Delete button
        //let deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Delete, target: self, action: "deleteMeme")
        let deleteButton = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: "deleteMeme")
        
        // Add the 2 buttons to the navigation items
        navigationItem.setRightBarButtonItems([editButton,deleteButton], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let detailMeme = meme {
            memeImage.image = detailMeme.memedImage
            memeImage.contentMode = .ScaleAspectFit
        }
    }
    
    func editMeme() {
        performSegueWithIdentifier("EditMeme", sender: self)
    }
    
    func deleteMeme() {
        super.deleteMeme(indexPath)
        navigationController!.popViewControllerAnimated(true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Transfer the meme to the editor
        if segue.identifier == "EditMeme" {
            let editorViewController = segue.destinationViewController as! EditorViewController
            editorViewController.meme = meme
        }
    }
    
}
