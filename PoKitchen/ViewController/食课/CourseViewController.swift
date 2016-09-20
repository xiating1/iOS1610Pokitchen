//
//  CourseViewController.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/18.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CourseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,QFHeaderViewDelegate {
    var relateId:String! = ""
    var dataArray = NSMutableArray()
    var seriesM:SeriesModel!
    var courseArray = NSMutableArray()//存放选集的数组
    
    
    lazy var tableView:UITableView = {
        
        let tableView = UITableView.init(frame: CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64), style: UITableViewStyle.Plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNib(UINib.init(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.headerView
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    lazy var headerView:QFHeaderView = {
        let headerView = QFHeaderView.init(frame: CGRectMake(0, 0, SCREEN_W, 300))
        headerView.delegate = self
        return headerView
    }()
    // MARK:QFHeaderView 协议方法
    func headerViewUpdateFrame(headerView: QFHeaderView) {
        //让TableView重新布局自己的headerView与表格的位置
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = headerView
    }
    func headerView(headerView: QFHeaderView, didSelectedIndex index: NSInteger) {
        let course = self.courseArray[index] as! CourseModel
        self.loadFriendData(course.courseId)
        self.loadRelateCourseData(course.courseId)
    }
    
    func playCourseAtIndex(index: NSInteger) {
        let course = self.courseArray[index] as! CourseModel
        let playItem = AVPlayerItem.init(URL: NSURL.init(string: course.courseVideo)!)
        let player = AVPlayer.init(playerItem: playItem)
        let avVC = AVPlayerViewController()
        avVC.player = player
        self.presentViewController(avVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        self.loadCommentData()
        self.loadCourseData()
        
    }
    //MARK: 加载点赞好友
    func loadFriendData(courseId:String)->Void{
        
        FriendModel.requestFriendData(courseId) { (array, error) in
            if error == nil {
                self.headerView.friendArray.removeAllObjects()
                self.headerView.friendArray.addObjectsFromArray(array!)
                self.headerView.friendView.reloadData()
                self.headerView.friendL.text = "\(array!.count)位厨友觉得很赞"
            }
            
        }
    }
    //MARK:获取相关课程数据
    func loadRelateCourseData(courseId:String)->Void{
        
        RelateCourse.requestRelateCourseData(courseId) { (array, error) in
            
            self.headerView.relateArray.removeAllObjects()
            self.headerView.relateArray.addObjectsFromArray(array!)
            self.headerView.relateView.reloadData()
        }

    }
    //MARK: - 加载选集内容
    func loadCourseData(){
        
        CourseModel.requestCourseData(self.relateId) { (model, array, error) in
            
            if error == nil{
                //model 课程系列模型，应该给记录下来
                self.seriesM = model!
                self.headerView.dishImageView.sd_setImageWithURL(NSURL.init(string: self.seriesM.seriesImage))
                let names = self.seriesM.seriesName.componentsSeparatedByString("#")
                
                self.headerView.nameL.text = names.last!
                self.headerView.updateL.text = "更新至\(self.seriesM.episode)集"
                self.courseArray.addObjectsFromArray(array!)
                //创建选集按钮
                self.headerView.createCourseBtns(array!)
            }
            
        }
    }
    
    //MARK:- 加载评论数据
    func loadCommentData(){
        HDManager.startLoading()
        CommentModel.requestCommentData(self.relateId) { (array, error) in
            
            if error == nil{
                self.dataArray.addObjectsFromArray(array!)
                self.tableView.reloadData()
                self.headerView.numOfCommentL.text = "\(self.dataArray.count)条发言"
            }
            HDManager.stopLoading()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - UITableView 协议方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell",forIndexPath: indexPath) as! CommentCell
        //取出模型并进行赋值
        let model = self.dataArray[indexPath.row] as! CommentModel
        
        //设置显示内容
        cell.headImage.sd_setImageWithURL(NSURL.init(string: model.headImg), placeholderImage: UIImage.init(named: "达人"))
        cell.nickL.text = model.nick
        cell.contentL.attributedText = model.atrr
        cell.timeL.text = model.createTime
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let model = self.dataArray[indexPath.row] as! CommentModel
        
        return model.cellHeight
    }
    
}
