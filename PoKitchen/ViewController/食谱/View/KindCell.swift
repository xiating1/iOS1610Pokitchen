//
//  KindCell.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/7/25.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit


protocol KindCellDelegate:class {
    
    func kindCellselectedTag(cell:KindCell,Index:NSInteger)->Void
}


class KindCell: UITableViewCell {

    @IBOutlet weak var cookImage: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var descriptionL: UILabel!
    weak var delegate:KindCellDelegate?
    var indexPath : NSIndexPath!
    
    @IBOutlet weak var tagView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    func setdisPlayModel(model:RecipeModel)->Void
    {
        self.titleL.text = model.title
        self.descriptionL.text = model.Description
        self.cookImage.sd_setImageWithURL(NSURL.init(string: model.image)!)
        for view in self.tagView.subviews
        {
            view.removeFromSuperview()
        }
        
        var i = 0
        var orginX : CGFloat = 0
        let btnH :CGFloat = 25
        let btnS :CGSize = CGSizeMake(100, 25)
        for tagInfo in model.tagsInfo!
        {
            let tag = tagInfo as! TagInfoModel
            
            let title:NSString = NSString(string:tag.text!)
            let rect = title.boundingRectWithSize(btnS, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
            let btn = UIButton.init(type: UIButtonType.Custom)
            btn.frame = CGRectMake(orginX + 15, 8, rect.size.width + 20, btnH)
            btn.tag = 1000 + i
            btn.titleLabel?.font = UIFont.systemFontOfSize(12)
            orginX += btn.frame.size.width + 15
            i += 1
            btn.layer.cornerRadius = btnH/2
            btn.layer.borderColor = UIColor.orangeColor().CGColor
            btn.layer.borderWidth = 0.8
            btn.setTitle(title as String, forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            self.tagView.addSubview(btn)
            btn.addTarget(self, action: #selector(self.tagViewDidSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        }
    }
    
    func tagViewDidSelected(button:UIButton)->Void
    {
        self.delegate?.kindCellselectedTag(self, Index: button.tag - 1000)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
