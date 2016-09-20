//
//  NavTitleView.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/14.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

/*声明按钮点击时需要通知其他视图设置偏移量*/

protocol NavTitleViewDelegate:class {
    
    func didSelectedTitleAtIndex(index:NSInteger)->Void
    
}


class NavTitleView: UIView {

    var btnW : CGFloat = 0 //按钮的宽度
    var space : CGFloat = 0  // 距离屏幕左端的距离
    var topSpce :CGFloat = 20 //按钮距离NavTitleView最顶端的距离
    var btnH:CGFloat = 23
    var sliderView:UIView!
    var selectedIndex = 0
    //声明代理属性，用于存代理对象
    weak var delegate:NavTitleViewDelegate?
    init(frame: CGRect,leftSpace:CGFloat,titleArray:[String]) {
        
        super.init(frame: frame)
        space = leftSpace
        //计算按钮的宽度
        btnW = (SCREEN_W - 2 * space) / CGFloat(titleArray.count)
        self.createSubviews(titleArray)
        
    }
    func createSubviews(titleArray:[String]){
        
        var i = 0
        
        for title in titleArray {
            let button = UIButton.init(frame: CGRectMake(CGFloat(i) * btnW, topSpce, btnW, btnH))
            //设置三种状态的标题
            button.setTitle(title, forState: UIControlState.Normal)
            button.setTitle(title, forState: UIControlState.Highlighted)
            button.setTitle(title, forState: UIControlState.Selected)
            button.tag = 200 + i
            
            button.setTitleColor(TEXTGRAYCOLOR, forState: UIControlState.Normal)
            button.setTitleColor(TEXTGRAYCOLOR, forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Selected)
            
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
            self.addSubview(button)
            button.addTarget(self, action: #selector(self.buttonIsClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            if i == 0{
                //设置选中
                button.selected = true
            }
            i += 1
        }
        
        sliderView = UIView.init(frame: CGRectMake(0, self.frame.size.height - 2, btnW, 2))
        sliderView.backgroundColor = UIColor.orangeColor()
        self.addSubview(sliderView)
    }
    func buttonIsClicked(button:UIButton){
        
        self.selectedIndex(button.tag - 200)
        //通知代理对象执行协议方法
        self.delegate?.didSelectedTitleAtIndex(button.tag - 200)
    }
    //当点击或滚到某一个下标位置时，改变按钮的选中状态
    func selectedIndex(index:NSInteger){
        //先取出上一次选中的按钮，并置为非选中状态
        let preBtn = self.viewWithTag(200 + self.selectedIndex) as! UIButton
        preBtn.selected = false
        //取出当前选中的按钮，设置为选中
        let button = self.viewWithTag(200 + index) as! UIButton
        button.selected = true
        selectedIndex = index
        //设置滑块的位置
        UIView.animateWithDuration(0.25) { 
            self.sliderView.mj_x = self.btnW * CGFloat(index)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
