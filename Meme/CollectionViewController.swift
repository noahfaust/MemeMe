//
//  CollectionViewController.swift
//  Meme
//
//  Created by Alexandre Gonzalo on 10/11/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 1.0
        let dimension = (view.frame.size.width - 2 * space) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        //cell.topText.text = meme.topText
        setLabelTextAttributes(cell.topText, text: meme.topText)
        cell.topText.textAlignment = .Center
        setLabelTextAttributes(cell.bottomText, text: meme.bottomText)
        cell.bottomText.textAlignment = .Center
        let imageView = UIImageView(image: meme.image)
        cell.backgroundView = imageView
        return cell
    }
    
    func setLabelTextAttributes(label: UILabel, text: String) {
        let memeTextAttributes = [
            NSFontAttributeName : UIFont(name: "Impact", size: 20)!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -2.0
        ]
        label.attributedText = NSAttributedString(string: text, attributes: memeTextAttributes)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[indexPath.item]
        
        //Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
