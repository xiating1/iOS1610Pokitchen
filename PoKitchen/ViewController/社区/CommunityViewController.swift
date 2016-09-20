//
//  CommunityViewController.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/12.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit
/**从ReCommendView 、AttentionView、 NewestView中 传出 ViewController */
protocol PushViewControllerDelegate:class {
    
    func pushViewController(destiationVC:UIViewController)->Void
}

class CommunityViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NavTitleViewDelegate,PushViewControllerDelegate {

    var titleView:NavTitleView!//导航title视图
    lazy var contentView : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        //设置为横向滚动
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let contentView = UICollectionView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 49), collectionViewLayout: layout)
        contentView.contentOffset = CGPointMake(SCREEN_W, 0)
        contentView.backgroundColor = GRAYCOLOR
        //设置按页滚动
        contentView.pagingEnabled = true
        contentView.showsHorizontalScrollIndicator = false
        //注册关注页面cell
        contentView.registerClass(AttentionView.self, forCellWithReuseIdentifier: "AttentionView")
        //注册推荐cell
        contentView.registerClass(RecommendView.self, forCellWithReuseIdentifier: "RecommendView")
        contentView.registerClass(NewestView.self, forCellWithReuseIdentifier: "NewestView")
        //指定数据源代理和操作代理
        contentView.delegate = self
        contentView.dataSource = self
        self.view.addSubview(contentView)
        return contentView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.contentView.reloadData()
        self.createTitleVeiw()
    }
    
    func createTitleVeiw(){
        
        titleView = NavTitleView.init(frame: CGRectMake(80, 20, SCREEN_W - 160, 44), leftSpace: 80, titleArray: ["关注","推荐","最新"])
        //指定代理关系
        titleView.delegate = self
        titleView.selectedIndex(1)
        self.navigationItem.titleView = titleView
    }
    //MARK:NavTitleView  协议方法
    
    func didSelectedTitleAtIndex(index: NSInteger) {
        //设置collectionView的偏移量
        self.contentView.contentOffset = CGPointMake(CGFloat(index) * SCREEN_W, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - UICollectionView 协议方法
    //返回三个页面
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cellID = ""
        if indexPath.item == 0
        {
            cellID = "AttentionView"
        }else if indexPath.item == 1{
            cellID = "RecommendView"
        }else{
            cellID = "NewestView"
        }
        let cell = contentView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
        
        if indexPath.item == 1{
            let cell1 = cell as! RecommendView
            cell1.delegate = self
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(SCREEN_W, SCREEN_H - 64 - 49)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }
    //结束滚动时
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = NSInteger(scrollView.contentOffset.x / SCREEN_W)
        titleView.selectedIndex(index)
    }
    //MARK:- PushViewControllerDelegate 协议方法
    func pushViewController(destiationVC: UIViewController) {
        
        destiationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(destiationVC, animated: true)
    }

    

}
