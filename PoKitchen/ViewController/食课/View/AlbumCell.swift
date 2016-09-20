//
//  AlbumCell.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/13.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {

    @IBOutlet weak var albumLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置圆
        self.albumLogo.layer.cornerRadius = self.albumLogo.frame.size.height / 2
        //裁剪多余的边界
        self.albumLogo.layer.masksToBounds = true
        
    }

}
