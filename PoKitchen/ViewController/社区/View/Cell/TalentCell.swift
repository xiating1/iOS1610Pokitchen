//
//  TalentCell.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/14.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class TalentCell: UICollectionViewCell {

    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nickL: UILabel!
    
    @IBOutlet weak var fansL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.headImage.layer.cornerRadius =  self.headImage.frame.size.height / 2
        //裁剪边界
        self.headImage.clipsToBounds = true
        self.fansL.textColor = TEXTGRAYCOLOR
    }

}
