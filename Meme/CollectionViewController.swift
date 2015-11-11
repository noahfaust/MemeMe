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
        
        // Set the cell dimensions
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
        
        // Set the top and bottom labels
        setLabelTextAttributes(cell.topText, text: meme.topText)
        setLabelTextAttributes(cell.bottomText, text: meme.bottomText)
        
        // Set the background view
        cell.backgroundView = UIImageView(image: meme.image)
        
        // Set the frame of the cell according to its size: Solve issue of label being misplace at first load
        cell.contentView.frame = cell.bounds;
        
        return cell
    }
    
    func setLabelTextAttributes(label: UILabel, text: String) {
        label.attributedText = NSAttributedString(string: text, attributes: getMemeTextAttributes(20.0))
        label.textAlignment = .Center
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        pushDetailViewController(indexPath)
    }
}
