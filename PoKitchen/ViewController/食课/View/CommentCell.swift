//
//  CommentCell.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/18.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nickL: UILabel!

    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var contentL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeL.textColor = TEXTGRAYCOLOR
        self.contentL.textColor = TEXTGRAYCOLOR
        self.headImage.layer.cornerRadius = self.headImage.mj_h / 2
        self.headImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
