//
//  NewDishCell.swift
//  PokechainDemo
//
//  Created by 夏婷 on 16/7/17.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class NewDishCell: UICollectionViewCell {

    
    @IBOutlet weak var dishImage: UIImageView!
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nickL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var zanNumL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.headImage.layer.cornerRadius = self.headImage.frame.size.width/2
        self.headImage.clipsToBounds = true
        self.timeL.textColor = UIColor.lightGrayColor()
        self.zanNumL.textColor = UIColor.lightGrayColor()
    }

}
