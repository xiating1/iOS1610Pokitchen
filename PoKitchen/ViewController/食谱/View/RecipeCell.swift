//
//  RecipeCell.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/12.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    
    @IBOutlet weak var dishImage: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var descripL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
