//
//  PanelCollectionViewController.swift
//  InfiniteCollectionView
//
//  Created by manish on 3/17/17.
//  Copyright © 2017 manish. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PanelCollectionViewController: UICollectionViewController {

    let dataSource = ["rose", "sunflower", "dahlia", "other"]
    var paddedDataSource: [String]! = nil
    var numberOfPanels: Int!
    var lineSpacing: CGFloat! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paddedDataSource = self.padDataSource(data: dataSource)
        numberOfPanels = dataSource.count
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(PanelCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        /// settin the item size
        if let collectionView = self.collectionView,
            let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let collectionSize = collectionView.bounds.size
            //            let collectionOrigin = collectionView.bounds.origin
            flowLayout.minimumLineSpacing = 0
            lineSpacing = flowLayout.minimumLineSpacing
            let itemSize = CGSize(width: collectionSize.width - lineSpacing,
                                  height: collectionSize.height)
            
            flowLayout.itemSize = itemSize
            
            //self.collectionView?.contentSize = CGSize(width: width, height: cellHeight * CGFloat(numberOfPanels))
        }
        self.collectionView?.clipsToBounds = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToInitialPosition()
    }
    
    lazy var scrollToInitialPosition: () -> Void = {
        self.collectionView?.scrollToItem(at: IndexPath(row: 1, section: 0),
                                          at: .left,
                                          animated: false)
        return {}
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paddedDataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PanelCell
        
        let origFrame = cell.frame
        
        cell.frame = CGRect(origin: CGPoint(x: origFrame.origin.x + lineSpacing / 2 , y: origFrame.origin.y),
                            size: origFrame.size)
        cell.setImage(image: paddedDataSource[indexPath.row])
        return cell
    }

    var lastOffset = CGFloat.leastNormalMagnitude
    var currentPage: Int = 0
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset
        
        if (CGFloat.leastNormalMagnitude == lastOffset) {
            lastOffset = currentOffset.x
            currentPage = 1
            return
        }
        
        let pageWidth = scrollView.frame.size.width
        if currentOffset.x < 0 {
            currentPage = -1
        } else {
            currentPage = Int(currentOffset.x.divided(by: pageWidth))
        }
        
        
        if currentPage < 0 {
            let destinationPage = currentPage + numberOfPanels + 1
            scrollView.contentOffset = CGPoint(x: CGFloat(destinationPage) * pageWidth, y: currentOffset.y)
        } else if currentPage > numberOfPanels {
            let destinationPage = 1
            scrollView.contentOffset = CGPoint(x: CGFloat(destinationPage) * pageWidth, y: currentOffset.y)
        }
    }

    
    // MARK: - private
    private func padDataSource(data: [String]) -> [String] {
        var updateData = data
        if (data.count > 0) {
            updateData.insert(data.last!, at: 0)
            updateData.append(data.first!)
        }
        return updateData
    }

}
