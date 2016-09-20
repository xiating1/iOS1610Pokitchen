//
//  DishCell.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/13.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class DishCell: UITableViewCell {

    
    @IBOutlet weak var dishImage: UIImageView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var updateL: UILabel!
    
    @IBOutlet weak var numL: UILabel!
    
    
    @IBOutlet weak var albumL: UILabel!
    
    
    @IBOutlet weak var albumLogo: UIImageView!
    
    //加载Xib文件成功之后调用的第一个函数，可以在这个方法中添加默认设置
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.albumLogo.layer.cornerRadius = self.albumLogo.frame.size.height / 2
        //裁剪边界
        self.albumLogo.clipsToBounds = true
        
        self.numL.textColor = TEXTGRAYCOLOR
        
        self.updateL.textColor = TEXTGRAYCOLOR
        
        self.albumL.textColor = TEXTGRAYCOLOR
        
        self.bottomView.backgroundColor = UIColor.whiteColor()
        
        self.contentView.backgroundColor = GRAYCOLOR

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
