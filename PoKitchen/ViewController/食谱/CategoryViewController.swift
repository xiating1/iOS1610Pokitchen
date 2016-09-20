//
//  CategoryViewController.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/7/25.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class CategoryViewController: UITableViewController,KindCellDelegate {

    var dataArray:NSMutableArray = NSMutableArray()
    var page:NSInteger = 1
    var categoryId:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib.init(nibName: "KindCell", bundle: nil), forCellReuseIdentifier: "KindCell")
        self.tableView.header = MJRefreshNormalHeader.init(refreshingBlock: { 
            self.page = 1
            self.loadData()
        })
        self.tableView.footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { 
            self.page += 1
            self.loadData()
        })
        
        loadData()
       
    }
    func loadData()
    {
        HDManager.startLoading()
        RecipeModel.loadKindWithId(categoryId, page: self.page) { (array, totalCount, error) in
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

    // MARK: - Table view data source



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentify = "KindCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentify, forIndexPath: indexPath) as! KindCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        let model = self.dataArray.objectAtIndex(indexPath.row) as! RecipeModel
        cell.setdisPlayModel(model)
        
        return cell
    }
    override  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 195
    }
  


}
