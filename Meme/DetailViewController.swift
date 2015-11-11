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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let detailMeme = meme {
            memeImage.image = detailMeme.memedImage
        }
    }
    
    func editMeme() {
        let editorViewController = storyboard?.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        editorViewController.meme = meme
        presentViewController(editorViewController, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditMeme" {
            let editorViewController = segue.destinationViewController as! EditorViewController
            editorViewController.meme = meme
        }
    }
    
}
