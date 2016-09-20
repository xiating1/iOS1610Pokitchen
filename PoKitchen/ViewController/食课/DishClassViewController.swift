//
//  DishClassViewController.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/12.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class DishClassViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var dataArray = NSMutableArray()// 存放食课列表数据
    var albumArray = NSMutableArray()// 存放顶端图标数据
    
    var page = 1
    
    lazy var tableView:UITableView = {
       
        let tableView = UITableView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 49), style: UITableViewStyle.Plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNib(UINib.init(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "DishCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
        //添加下拉刷新和上拉加载更多
        
        tableView.header = MJNewNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadCourseData()
        })
        tableView.footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { 
            self.page += 1
            self.loadCourseData()
        })
        
        self.view.addSubview(tableView)
        return tableView
    }()
    
    lazy var albumView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        //设置横向滚动
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        //最小列间距
        layout.minimumInteritemSpacing = 5
        //最小行间距
        layout.minimumLineSpacing = 0
        
        let albumView = UICollectionView.init(frame: CGRectMake(0, 64, SCREEN_W, 80), collectionViewLayout: layout)
        albumView.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8)
        //设置横向滚动条隐藏
        albumView.showsHorizontalScrollIndicator = false
        //注册cell
        albumView.registerNib(UINib.init(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCell")
        albumView.delegate = self
        albumView.dataSource = self
        self.view.addSubview(albumView)
        return albumView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadCourseData()
        
        self.loadAlbumData()
        
    }
    
    //MARK: 请求顶端图标数据
    func loadAlbumData(){
        //将加载指示器显示在窗口上
        HDManager.startLoading()
        AlbumModel.requestAlbumData { (array, error) in
          
            if error == nil{
                self.albumArray.addObjectsFromArray(array!)
                self.albumView.reloadData()
                self.view.bringSubviewToFront(self.albumView)
            }
            //将加载指示器隐藏
            HDManager.stopLoading()
        }
        
    }
    //MARK:请求食课列表数据
    func loadCourseData(){
        
        HDManager.startLoading()
        let clouser:(array:[AnyObject]?,err:NSError?)->Void = { (dishArray,error) in
            
            if error == nil {
                
                self.dataArray.addObjectsFromArray(dishArray!)
                self.tableView.reloadData()
                self.view.sendSubviewToBack(self.tableView)
                //结束刷新
                self.tableView.header.endRefreshing()
                self.tableView.footer.endRefreshing()
            }
            HDManager.stopLoading()
        }
        
        DishModel.requestCourseData(self.page, callBack: clouser)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- UICollectionView协议方法
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.albumArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
        //取出模型
        let model = self.albumArray[indexPath.item] as! AlbumModel
        cell.albumLogo.sd_setImageWithURL(NSURL.init(string: model.albumLogo))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(80, 80)
    }
    

   
    // MARK: - UITableView 协议方法
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DishCell", forIndexPath: indexPath) as! DishCell
        //取出模型
        let  model = self.dataArray[indexPath.row] as! DishModel
        
        cell.dishImage.sd_setImageWithURL(NSURL.init(string: model.image))
        
        cell.albumLogo.sd_setImageWithURL(NSURL.init(string: model.albumLogo))
        
        let array = model.seriesName.componentsSeparatedByString("#")
        cell.nameL.text = array.last
        
        cell.updateL.text = "更新至\(model.episode)集"
        
        cell.numL.text = "上课人数:\(model.play)"
        cell.albumL.text = model.album
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 240
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //食课详情界面
        let courseVC = CourseViewController()
        
        //取出相应课程的系列ID
        
        let model = self.dataArray[indexPath.row] as! DishModel
        courseVC.relateId = model.seriesId
        courseVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(courseVC, animated: true)
    }

}
