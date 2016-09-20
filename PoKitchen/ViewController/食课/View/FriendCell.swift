//
//  FriendCell.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/19.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class FriendCell: UICollectionViewCell {

    @IBOutlet weak var headImge: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headImge.layer.cornerRadius = self.headImge.mj_h / 2
        self.headImge.clipsToBounds = true
    }

}
