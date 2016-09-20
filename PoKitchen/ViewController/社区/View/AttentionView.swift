//
//  AttentionView.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/14.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class AttentionView: UICollectionViewCell {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.cyanColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
