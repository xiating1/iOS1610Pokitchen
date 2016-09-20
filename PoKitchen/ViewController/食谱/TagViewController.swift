//
//  TagViewController.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/7/26.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class TagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,KindCellDelegate {

    var kindId:String! = ""
    var page : NSInteger = 1
    var dataArray:NSMutableArray = NSMutableArray()
    lazy var tableView:UITableView = {
        
        let tableView = UITableView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64), style: UITableViewStyle.Plain)
        tableView.registerNib(UINib.init(nibName: "KindCell", bundle: nil), forCellReuseIdentifier: "KindCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.header = MJRefreshNormalHeader.init(refreshingBlock: { 
            self.page = 1
            self.loadData()
        })
        tableView.footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { 
            self.page += 1
            self.loadData()
        })
        
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        self.loadData()
        
    }

    func  loadData()
    {
        HDManager.startLoading()
        RecipeModel.searchKind(kindId, page: self.page) { (array, totalCount, error) in
            
            if error == nil
            {
                if self.page == 1
                {
                    self.dataArray.removeAllObjects()
                }
                self.dataArray.addObjectsFromArray(array!)
                self.tableView.reloadData()
                self.tableView.header.endRefreshing()
                self.tableView.footer.endRefreshing()
            }
            HDManager.stopLoading()
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - UITableView协议方法

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cellIdentify = "KindCell"
        let  cell = tableView.dequeueReusableCellWithIdentifier(cellIdentify, forIndexPath: indexPath) as! KindCell
        cell.indexPath = indexPath
        cell.delegate = self
        
        let dish = self.dataArray.objectAtIndex(indexPath.row) as! RecipeModel
        cell.setdisPlayModel(dish)
        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 195
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.dataArray.objectAtIndex(indexPath.row) as! RecipeModel
        
        let playerItem = AVPlayerItem.init(URL: NSURL.init(string: model.video)!)
        let playerItem1 = AVPlayerItem.init(URL: NSURL.init(string: model.video1)!)
        let palyer = AVQueuePlayer.init(items: [playerItem,playerItem1])
        let avVC = AVPlayerViewController()
        avVC.player = palyer
        self.presentViewController(avVC, animated: true, completion: nil)
        
    }
    func kindCellselectedTag(cell: KindCell, Index: NSInteger) {
        
        let model = self.dataArray.objectAtIndex(cell.indexPath.row) as! RecipeModel
        let  tagInfo = model.tagsInfo?.objectAtIndex(Index) as! TagInfoModel
        let tagVC = TagViewController()
        tagVC.kindId = tagInfo.id
        self.navigationController?.pushViewController(tagVC, animated: true)
        
        
    }

}
