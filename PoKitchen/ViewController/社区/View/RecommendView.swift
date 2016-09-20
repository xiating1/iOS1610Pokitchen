//
//  RecommendView.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/14.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class RecommendView: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource,RecommendCellDataSource,RecommendCellDelegate {
    
    var dataArray = NSMutableArray()
    weak var delegate:PushViewControllerDelegate?
    
    lazy var tableView : UITableView = {
        
        let tableView = UITableView.init(frame: CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 49), style: UITableViewStyle.Plain)
        tableView.registerNib(UINib.init(nibName: "RecommendCell", bundle: nil), forCellReuseIdentifier: "RecommendCell")
        self.contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.cyanColor()
        self.loadData()
    }
    func loadData(){
        
        TopicModel.requestCommunityData { (banner, array, error) in
            
            if error == nil{
                self.dataArray.addObjectsFromArray(array!)
                self.tableView.reloadData()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- UITableView协议方法
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecommendCell",forIndexPath: indexPath) as! RecommendCell
        cell.indexPath = indexPath
        //指定代理
        cell.dataSouce = self
        cell.delegate = self
        cell.collectionView.reloadData()
        if indexPath.row == 0{
            //掌厨达人
            cell.titleL.text = "掌厨达人"
            cell.icon.image = UIImage.init(named: "达人")
        }else if indexPath.row == 1{
            //精选作品
            cell.titleL.text = "精选作品"
            cell.icon.image = UIImage.init(named: "精品")
        }else{
            //取出专题模型，设置标题
            let model = self.dataArray[indexPath.row] as! TopicModel
            cell.titleL.text = model.topicName
            cell.icon.image = UIImage.init(named: "标签")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 200
    }
    //MARK:- RecommendCellDataSource 协议方法
    
    func numberOfItemsInRow(row: NSInteger) -> NSInteger {
        
        if row == 0 || row == 1{
            //掌厨达人的个数
            let array = self.dataArray[row] as! [AnyObject]
            return array.count
            
        }else{
            //取出专题模型
            let model = self.dataArray[row] as! TopicModel
            //返回专题中的菜品个数
            return (model.data?.count)!
        }
    }
    
    func cellForItemInRow(row: NSInteger, index: NSInteger, collectionView: UICollectionView) -> UICollectionViewCell {
        
        if row == 0{
            //返回掌厨达人的cell
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TalentCell", forIndexPath: NSIndexPath.init(forItem: index, inSection: 0)) as! TalentCell
            //取出掌厨达人模型  准备赋值
            let talent = self.dataArray[row][index] as! TalentModel
            //设置头像
            cell.headImage.sd_setImageWithURL(NSURL.init(string: talent.headImg))
            cell.nickL.text = talent.nick
            
            cell.fansL.text = "粉丝:\(talent.tongjiBeFollow)"
            return cell
        }else if row == 1{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecommendDishCell", forIndexPath: NSIndexPath.init(forItem: index, inSection: 0)) as! RecommendDishCell
            let marrow = self.dataArray[row][index] as! MarrowModel
            cell.dishImage.sd_setImageWithURL(NSURL.init(string: marrow.image))
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecommendDishCell", forIndexPath: NSIndexPath.init(forItem: index, inSection: 0)) as! RecommendDishCell
            let topic = self.dataArray[row] as! TopicModel
            let dishModel = topic.data![index] as! TopicDishModel
            cell.dishImage.sd_setImageWithURL(NSURL.init(string: dishModel.image))
            return cell
        }
        
    }
    
    func sizeForItemInRow(row: NSInteger, index: NSInteger) -> CGSize {
        
        return CGSizeMake(135, 135)
    }
    //MARK:- RecommendCellDelegate 协议方法
    
    func didSelectedTitleInRow(row: NSInteger) {
        
        if row == 0{
            let talentList = TalentListViewController()
            //取出相关数据
            talentList.title = "达人列表"
            //  将talentList 传递给 RecommendVeiwController
            self.delegate?.pushViewController(talentList)
        }
        
    }
    func didSelectedCellInRow(row: NSInteger, index: NSInteger) {
        
        if row == 0 {
            //选中掌厨达人
            //取出模型
            let talent = self.dataArray[row][index] as! TalentModel
            
            let talentVC = TalentViewController()
            talentVC.title = "达人:\(talent.nick)"
            //  将talentVC 传递给 RecommendVeiwController
            self.delegate?.pushViewController(talentVC)

        }
        
    }
    
}
