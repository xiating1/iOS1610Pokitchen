//
//  NewestView.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/14.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class NewestView: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var dataArray:NSMutableArray! = NSMutableArray()
    let space:CGFloat = 2
    var page:NSInteger = 1
    lazy var dishView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.minimumInteritemSpacing = self.space
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView.init(frame: CGRectMake(-20, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 64 - 49), collectionViewLayout: layout)
        cv.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        cv.registerNib(UINib.init(nibName: "NewDishCell", bundle: nil), forCellWithReuseIdentifier: "NewDishCell")
        cv.header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData()
        })
        cv.footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.loadData()
        })
        
        return cv
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.loadData()
        
    }
    
    func loadData()->Void
    {
        HDManager.startLoading()
        NewestDish.getNewestDishes(self.page) { (array, error) in
            if error == nil
            {
                self.contentView.addSubview(self.dishView)
                if self.page == 1
                {
                    self.dataArray.removeAllObjects()
                }
                self.dataArray.addObjectsFromArray(array! as [AnyObject])
                self.dishView.reloadData()
                self.dishView.header.endRefreshing()
                self.dishView.footer.endRefreshing()
            }
            HDManager.stopLoading()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-UICollectView协议方法
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentify = "NewDishCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentify, forIndexPath: indexPath) as! NewDishCell
        let dish = self.dataArray.objectAtIndex(indexPath.item) as! NewestDish
        cell.dishImage.sd_setImageWithURL(NSURL.init(string: dish.image))
        cell.headImage.sd_setImageWithURL(NSURL.init(string: dish.headImg))
        cell.nickL.text = dish.nick
        cell.timeL.text = dish.createTime
        cell.zanNumL.text = dish.agreeCount
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((UIScreen.mainScreen().bounds.size.width - space)/2, 220)
    }
    
}

