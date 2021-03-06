//
//  ViewController.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 23/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var items = [Character]()
    
    private var currentPage: Int = 0 {
        didSet {
            let character = self.items[self.currentPage]
            self.infoLabel.text = character.name.uppercaseString
            self.detailLabel.text = character.movie.uppercaseString
        }
    }
    
    private var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .Horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    private var orientation: UIDeviceOrientation {
        return UIDevice.currentDevice().orientation
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.items = self.createItems()
        
        self.currentPage = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.rotationDidChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    private func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
    
    private func createItems() -> [Character] {
        let characters = [
            Character(imageName: "wall-e", name: "Wall-E", movie: "Wall-E"),
            Character(imageName: "nemo", name: "Nemo", movie: "Finding Nemo"),
            Character(imageName: "ratatouille", name: "Remy", movie: "Ratatouille"),
            Character(imageName: "buzz", name: "Buzz Lightyear", movie: "Toy Story"),
            Character(imageName: "monsters", name: "Mike & Sullivan", movie: "Monsters Inc."),
            Character(imageName: "brave", name: "Merida", movie: "Brave")
        ]
        return characters
    }
    
    
    @objc private func rotationDidChange() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let direction: UICollectionViewScrollDirection = UIDeviceOrientationIsPortrait(orientation) ? .Horizontal : .Vertical
        layout.scrollDirection = direction
        if currentPage > 0 {
            let indexPath = NSIndexPath(forItem: currentPage, inSection: 0)
            let scrollPosition: UICollectionViewScrollPosition = UIDeviceOrientationIsPortrait(orientation) ? .CenteredHorizontally : .CenteredVertically
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: false)
        }
    }
    
    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CarouselCollectionViewCell.identifier, forIndexPath: indexPath) as! CarouselCollectionViewCell
        let character = items[indexPath.row]
        cell.image.image = UIImage(named: character.imageName)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let character = items[indexPath.row]
        let alert = UIAlertController(title: character.name, message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .Horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .Horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }

}

