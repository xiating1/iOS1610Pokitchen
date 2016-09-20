//
//  HomeViewController.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/12.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createViewControllers()
    }
    func createViewControllers(){
        
        let recipe = RecipeViewController()
        
        let like = LikeViewController()
        
        let community = CommunityViewController()
        
        let dishClass = DishClassViewController()
        
        let mine = MineViewController()
        
        let vcArray = [recipe,like,community,dishClass,mine]
        
        let titleArray = ["食谱","喜欢","社区","食课","我的"]
        var i = 0 //用于控制标题的变量
        var viewControllers = [UINavigationController]()//用于存放五个模块的导航控制器
        for vc in vcArray{
            
            let nav = UINavigationController.init(rootViewController: vc)
            let title = titleArray[i]
            //设置标题
            nav.title = title
            //非选中效果图片  总是显示原色
            let image = UIImage.init(named: title + "A")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            //选中效果的图片 总是显示原色
            let imageS = UIImage.init(named: title + "B")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            //创建Item
            let tabItem = UITabBarItem.init(title: title, image: image, selectedImage: imageS)
            nav.tabBarItem = tabItem
            //非选中效果字体和字体颜色
            tabItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(12),NSForegroundColorAttributeName:TEXTGRAYCOLOR], forState: UIControlState.Normal)
            //选中效果字体和字体颜色
            
            tabItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(12),NSForegroundColorAttributeName:UIColor.orangeColor()], forState: UIControlState.Selected)
            //调整图片的显示位置 上下 设置为一对相反数  否则点击效果有问题
            tabItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)
            //添加到数组中
            viewControllers.append(nav)
            i += 1
            
        }
        self.viewControllers = viewControllers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
