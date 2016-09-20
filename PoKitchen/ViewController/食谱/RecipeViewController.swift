//
//  RecipeViewController.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/12.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class RecipeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    //存放分类模型的数组
    var categoryArray =  NSMutableArray()
    
    //存放食谱模型的数组
    var dataArray = NSMutableArray()
    
    lazy var tableView:UITableView = {
        
        let tableView = UITableView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 49), style: UITableViewStyle.Grouped)
        tableView.tableHeaderView = self.headerView
        tableView.registerNib(UINib.init(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        return tableView
    }()
    //组合轮播视图和 分类按钮两个子视图
    lazy var headerView:UIView = {
        
        let headerView = UIView.init(frame: CGRectMake(0, 0, SCREEN_W, 320))
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(self.adView)
        return headerView
    }()
    
    lazy var adView:XTADScrollView = {
        let adView = XTADScrollView.init(frame: CGRectMake(0, 0, SCREEN_W, 120))
        //是否启动轮播
        adView.infiniteLoop = true
        //是否显示pageControl
        adView.needPageControl = true
        //pageControl显示的位置
        adView.pageControlPositionType = pageControlPositionTypeRight
        return adView
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false 
        self.loadData()
    }
    //MARK:- 获取网络数据
    func loadData(){
        
        RecipeModel.requestHomeData { (bannerArray, cateArray, array, error) in
            //UI 刷新
            if error == nil {
                
                self.dataArray.addObjectsFromArray(array!)
                self.tableView.reloadData()
                //给轮播视图设置图片数组
                self.adView.imageURLArray = bannerArray
                self.categoryArray.addObjectsFromArray(cateArray!)
                self.createCategoryBtns()
            }else{
                print("请求出错")
            }
            
        }

    }
    //创建分类按钮
    func createCategoryBtns(){
        
        let subView = UIView.init(frame: CGRectMake(0, 120, SCREEN_W, 200))
        self.headerView.addSubview(subView)
        let space:CGFloat = 20
        let btnW:CGFloat = (SCREEN_W - 5 * space) / 4
        //重设透视图的高度
        self.headerView.frame = CGRectMake(0, 0, SCREEN_W, 2 * (space +  btnW) + space + 120)
        
        var i = 0
        for model in self.categoryArray{
            
            let orginX = CGFloat(i % 4) * (btnW + space) + space
            let orginY = CGFloat(i / 4) * (btnW + space) + space
            
            let button = UIButton.init(frame: CGRectMake(orginX, orginY, btnW, btnW))
            let m = model as! CategoryModel
            //设置图片
            button.sd_setBackgroundImageWithURL(NSURL.init(string: m.image), forState: UIControlState.Normal)
            button.sd_setBackgroundImageWithURL(NSURL.init(string: m.image), forState: UIControlState.Selected)
            button.setTitle(m.text, forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            subView.addSubview(button)
            //设置标题颜色
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            // 设置标题的偏移量
            button.titleEdgeInsets = UIEdgeInsetsMake(btnW + space, 0, 0, 0)
            button.addTarget(self, action: #selector(self.categoryBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = 100 + i
            i += 1
        }
        
    }
    //分类按钮被点击
    func categoryBtnClicked(button:UIButton){
        
        //点击分类时，往下层跳转，对应的接口是分类详情
        //分类按钮被点击
        let model = self.categoryArray.objectAtIndex(button.tag - 100) as! CategoryModel
        let cateVC = CategoryViewController()
        cateVC.categoryId = model.id
        cateVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cateVC, animated: true)
        
        print("第",button.tag - 100,"分类被点击")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableView 协议方法
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = self.dataArray[section] as! [AnyObject]
        return array.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as! RecipeCell
        //取出对应组的数据源
        let sectionArray = self.dataArray[indexPath.section] as! [RecipeModel]
        let model = sectionArray[indexPath.row]
        //设置显示图片
        cell.dishImage.sd_setImageWithURL(NSURL.init(string: model.image))
        cell.titleL.text = model.title
        cell.descripL.text = model.Description
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 165
    }
    //MARK: 组头视图相关的协议方法
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel.init(frame: CGRectMake(0, 0, SCREEN_W, 25))
        label.backgroundColor = UIColor.whiteColor()
        label.textColor = UIColor.orangeColor()
        label.font = UIFont.systemFontOfSize(18)
        let array = ["| 热门推荐  >","| 新品推荐  >","| 排行榜  >","| 主题推荐  >"]
        label.text = array[section]
        return label
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    //点击视频播放
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let sectionArray = self.dataArray[indexPath.section] as! [RecipeModel]
        //取出食谱模型
        let model = sectionArray[indexPath.row]
        
        //创建播放源
        let playItem = AVPlayerItem.init(URL: NSURL.init(string: model.video)!)
        let playItem1 = AVPlayerItem.init(URL: NSURL.init(string: model.video1)!)
        let player = AVQueuePlayer.init(items: [playItem,playItem1])
        
        let playerVc = AVPlayerViewController()
        //设置播放器
        playerVc.player = player
        //弹出播放视图
        self.presentViewController(playerVc, animated: true, completion: nil)
        
    }
}
