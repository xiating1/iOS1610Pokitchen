//
//  LikeViewController.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/12.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,KindCellDelegate {
    
    /**懒加载*/
    lazy var dataArray:NSMutableArray = {
        
        return NSMutableArray()
        
    }()
    lazy var tableView:UITableView =
        {
            let table = UITableView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 49), style: UITableViewStyle.Plain)
            table.delegate = self
            table.dataSource = self
            table.registerNib(UINib.init(nibName: "KindCell", bundle: nil), forCellReuseIdentifier: "KindCell")
            return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    //MARK:加载数据
    func loadData()->Void
    {
        HDManager.startLoading()
        LikeModel.requestLikeModels(1) { (likeArray, totalCount, error) in
            if error == nil
            {
                self.dataArray.addObjectsFromArray(likeArray!)
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
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
        let cellIdentify = "KindCell"
        let cell:KindCell = tableView.dequeueReusableCellWithIdentifier(cellIdentify, forIndexPath: indexPath) as! KindCell
        cell.indexPath = indexPath
        cell.delegate = self
        let  model = self.dataArray.objectAtIndex(indexPath.row) as! RecipeModel
        cell.setdisPlayModel(model)
        return cell
    }
    //选中标签
    func kindCellselectedTag(cell: KindCell, Index: NSInteger) {
        
        let model = self.dataArray.objectAtIndex(cell.indexPath.row) as! RecipeModel
        let  tagInfo = model.tagsInfo?.objectAtIndex(Index) as! TagInfoModel
        let tagVC = TagViewController()
        tagVC.kindId = tagInfo.id
        self.navigationController?.pushViewController(tagVC, animated: true)
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 200
    }
}
