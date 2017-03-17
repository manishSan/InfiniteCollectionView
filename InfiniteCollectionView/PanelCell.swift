//
//  PanelCell.swift
//  InfiniteCollectionView
//
//  Created by manish on 3/17/17.
//  Copyright © 2017 manish. All rights reserved.
//

import UIKit

class PanelCell: UICollectionViewCell {
    private var bkImageView: UIImageView?
    
    private func imageView() -> UIImageView {
        if bkImageView == nil {
            let refFrame = self.bounds
            let frame = CGRect(x: refFrame.origin.x,
                               y: refFrame.origin.y,
                               width: refFrame.size.width,
                               height: refFrame.size.height)
            bkImageView = UIImageView(frame: frame)
            self.addSubview(bkImageView!)
        }
        return bkImageView!
    }
    
    func setImage(image: String) {
        self.imageView().image = UIImage(named: image)
    }
}
