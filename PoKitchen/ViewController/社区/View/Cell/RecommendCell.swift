//
//  RecommendCell.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/14.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

/**
1. RecommendCell 能够显示TalentCell 和 RecommendDishCell,但是不能够创建这两中cell,原因是没有数据
2. ReCommendView 有能够创建TalentCell 和 RecommendDishCell 的数据，也能够创建cell
 
 3. 我们希望RecommendCell 要显示 具体的TalentCell 或 RecommendDishCell的时候，去找ReCommendView 获取 
  1> 每一行的collentView中要显示侧item 个数
  2> 显示的具体的cell
 
 4.RecommendCell 去获取数据或cell需要告诉 ReCommendView 自己所在的位置，获取item 个数是，需要提供所在的行下标；获取具体的cell 时要提供所在的行下标，和 在collectionView中的item下标
 */

protocol RecommendCellDataSource:class {
    //从ReCommendView 获取某一行的item个数
    func numberOfItemsInRow(row:NSInteger)->NSInteger
    //从ReCommendView 中获取某一个具体的cell
    func cellForItemInRow(row:NSInteger,index:NSInteger,collectionView:UICollectionView)->UICollectionViewCell
    //布局相关的，返回某一个cell的大小
    func sizeForItemInRow(row:NSInteger,index:NSInteger)->CGSize
    
}
/**
  1. 点击title时，通知RecommendView执行 获取相关信息（达人、精选作品,专题）,创建一个ViewController 
  2.RecommendView 把第一种创建的ViewController 传递个RecommunityViewController,并将其push到下一层
 */
/**这一个协议只实现第1步的操作*/
protocol RecommendCellDelegate:class {
    //选中某一行的标题
    func didSelectedTitleInRow(row:NSInteger)->Void
    
    //选中具体的某一个collectionViewCell
    func didSelectedCellInRow(row:NSInteger,index:NSInteger)->Void
}

class RecommendCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var dataSouce:RecommendCellDataSource!
    weak var delegate:RecommendCellDelegate?
    var indexPath:NSIndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = GRAYCOLOR
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        self.titleL.superview?.backgroundColor = UIColor.whiteColor()
        self.collectionView.registerNib(UINib.init(nibName: "TalentCell", bundle: nil), forCellWithReuseIdentifier: "TalentCell")
        self.collectionView.registerNib(UINib.init(nibName:"RecommendDishCell", bundle: nil), forCellWithReuseIdentifier: "RecommendDishCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        //隐藏横向滚动条
        self.collectionView.showsHorizontalScrollIndicator = false
        
        //给title部分添加点击手势
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.titleTaped))
        self.titleL.superview?.addGestureRecognizer(gesture)
        //去掉选中效果
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    //标题被点击
    func titleTaped()->Void{
      self.delegate?.didSelectedTitleInRow(self.indexPath.row)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK:UICollectionView 的协议方法
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataSouce.numberOfItemsInRow(self.indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        return self.dataSouce.cellForItemInRow(self.indexPath.row, index: indexPath.item, collectionView: collectionView)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return self.dataSouce.sizeForItemInRow(self.indexPath.row, index: indexPath.item)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.didSelectedCellInRow(self.indexPath.row, index: indexPath.item)
    }
}
