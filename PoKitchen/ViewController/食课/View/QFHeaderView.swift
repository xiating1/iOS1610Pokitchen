//
//  QFHeaderView.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/18.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit


protocol QFHeaderViewDelegate:class {
    //更新高度
    func headerViewUpdateFrame(headerView:QFHeaderView)->Void
    //选中某一个选集按钮
    func headerView(headerView:QFHeaderView, didSelectedIndex index:NSInteger)->Void
    
    //播放视频
    func playCourseAtIndex(index: NSInteger)->Void
    
}

class QFHeaderView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var dishImageView:UIImageView!
    var numL:UILabel!//上课人数
    var nameL:UILabel!//课程名字
    var contentL:UILabel!//详细说明
    var isShow:Bool = false // 记录详情说明的显示或隐藏状态
    
    // 第二部分 
    
    var updateL:UILabel! //显示更新至多少集
    var courseView:UIView!//显示选集按钮的父视图
    var courseShow:Bool = false //超过16集之后的选集按钮时隐藏还是显示
    
    //第三部分 
    var bottomView:UIView! //第三部分父视图
    var friendL:UILabel! // 显示点赞好友个数
    var friendView:UICollectionView!//显示点赞好友的头像
    
    var relateView:UICollectionView!//显示相关课程的图片
    var numOfCommentL:UILabel!//显示评论条数
    
    var topSpace:CGFloat = 10
    var leftSpace:CGFloat = 15
    
    let space:CGFloat = 5 //选集按钮之间的距离
    var btnW:CGFloat = 0 // 选集按钮的宽高
    
    var courseArray = NSMutableArray()
    var selectedIndex = 0 // 当前选中的选集在数组中的下标
    
    weak var delegate:QFHeaderViewDelegate?
    var friendArray = NSMutableArray()//存放点赞好友数据
    var relateArray = NSMutableArray()//存放相关课程数据
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }

    //创建所有的子视图
    func createSubviews(){
      
        dishImageView = UIImageView.init(frame: CGRectMake(0, 0, SCREEN_W, 200))
        self.addSubview(dishImageView)
        dishImageView.userInteractionEnabled = true
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(self.playTaped))
        dishImageView.addGestureRecognizer(ges)
        
        let play = UIImageView.init(frame: CGRectMake(0, 0, 50, 50))
        play.center = dishImageView.center
        play.image = UIImage.init(named: "首页-播放")
        dishImageView.addSubview(play)
        
        numL = UILabel.init(frame: CGRectMake(leftSpace, dishImageView.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 23))
        numL.textColor = TEXTGRAYCOLOR
        numL.font = UIFont.systemFontOfSize(16)
        numL.text = "上课人数:4352"
        self.addSubview(numL)
        
        nameL = UILabel.init(frame: CGRectMake(leftSpace, numL.mj_y + numL.mj_h + topSpace, SCREEN_W - 2 * leftSpace - 50, 23))
        nameL.textColor = UIColor.blackColor()
        nameL.font = UIFont.systemFontOfSize(17)
        self.addSubview(nameL)
        
        let showBtn = UIButton.init(frame: CGRectMake(SCREEN_W - leftSpace - 30, nameL.mj_y - 3, 30, 30))
        showBtn.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Normal)
        showBtn.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Highlighted)
        showBtn.addTarget(self, action: #selector(self.showOrHiddenContent(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(showBtn)
        
        contentL = UILabel.init(frame: CGRectMake(leftSpace, nameL.mj_y + nameL.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 0))
        
        contentL.textColor = TEXTGRAYCOLOR
        contentL.font = UIFont.systemFontOfSize(15)
        contentL.numberOfLines = 0
        self.addSubview(contentL)
        
        //第二部分 
        courseView = UIView.init(frame: CGRectMake(0, contentL.mj_y + contentL.mj_h, SCREEN_W, 120))
        let xuanjiL = UILabel.init(frame: CGRectMake(leftSpace, 25, 100, 23))
        xuanjiL.textColor = UIColor.blackColor()
        xuanjiL.font = UIFont.systemFontOfSize(16)
        xuanjiL.text = "选集"
        courseView.addSubview(xuanjiL)
        
        updateL = UILabel.init(frame: CGRectMake(SCREEN_W - leftSpace - 25 - 120, xuanjiL.mj_y, 120, 23))
        updateL.textColor = TEXTGRAYCOLOR
        updateL.font = UIFont.systemFontOfSize(16)
        updateL.textAlignment = NSTextAlignment.Right
        updateL.text = "更新至1集"
        courseView.addSubview(updateL)
        
        let btn = UIButton.init(frame: CGRectMake(SCREEN_W - leftSpace - 30, updateL.mj_y - 3, 30, 30))
        btn.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Highlighted)

        btn.addTarget(self, action: #selector(self.showOrHiddenCourse(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        courseView.addSubview(btn)
        
        //第三部分
        bottomView = UIView.init(frame: CGRectMake(0, courseView.mj_y + courseView.mj_h, SCREEN_W, 300))
        friendL = UILabel.init(frame: CGRectMake(leftSpace, 35, 180, 23))
        friendL.textColor = UIColor.blackColor()
        friendL.font = UIFont.systemFontOfSize(16)
        friendL.text = "15位厨友觉得很赞"
        bottomView.addSubview(friendL)
        
        let zanBtn = UIButton.init(frame: CGRectMake(friendL.mj_x + friendL.mj_w + leftSpace, friendL.mj_y, 30, 30))
        zanBtn.setImage(UIImage.init(named: "agree"), forState: UIControlState.Normal)
        bottomView.addSubview(zanBtn)
        
        // 点赞好友视图
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 2
        
        friendView = UICollectionView.init(frame: CGRectMake(leftSpace, friendL.mj_y + friendL.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 80), collectionViewLayout: layout)
        friendView.backgroundColor = UIColor.whiteColor()
        friendView.showsHorizontalScrollIndicator = false
        
        friendView.registerNib(UINib.init(nibName: "FriendCell", bundle: nil), forCellWithReuseIdentifier: "FriendCell")
        friendView.delegate = self
        friendView.dataSource = self
        
        bottomView.addSubview(friendView)
        
        //
        let relateL = UILabel.init(frame: CGRectMake(leftSpace, friendView.mj_y + friendView.mj_h + topSpace, 150, 23))
        relateL.textColor = UIColor.blackColor()
        relateL.font = UIFont.systemFontOfSize(16)
        relateL.text = "相关课程"
        bottomView.addSubview(relateL)
        
        //
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout2.minimumLineSpacing = 2
        layout2.minimumInteritemSpacing = 2
        relateView = UICollectionView.init(frame: CGRectMake(leftSpace, relateL.mj_y + relateL.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 200), collectionViewLayout: layout2)
        relateView.backgroundColor = UIColor.whiteColor()
        relateView.showsHorizontalScrollIndicator = false
        relateView.registerNib(UINib.init(nibName: "RelateCourseCell", bundle: nil), forCellWithReuseIdentifier: "RelateCourseCell")
        relateView.delegate = self
        relateView.dataSource = self
        
        bottomView.addSubview(relateView)
        
        numOfCommentL = UILabel.init(frame: CGRectMake(leftSpace, relateView.mj_y + relateView.mj_h, SCREEN_W - 2 * leftSpace, 23))
        numOfCommentL.textColor = UIColor.blackColor()
        numOfCommentL.font = UIFont.systemFontOfSize(16)
        numOfCommentL.text = "20条发言"
        bottomView.addSubview(numOfCommentL)
        
        let fayanL = UILabel.init(frame: CGRectMake(leftSpace, numOfCommentL.mj_y + numOfCommentL.mj_h + topSpace, SCREEN_W - 2 * leftSpace, 30))
        fayanL.backgroundColor = UIColor.orangeColor()
        fayanL.textColor = UIColor.whiteColor()
        fayanL.font = UIFont.systemFontOfSize(20)
        fayanL.textAlignment = NSTextAlignment.Center
        fayanL.text = "课堂发言"
        bottomView.addSubview(fayanL)
        //重设第三部分的高度
        bottomView.mj_h = fayanL.mj_y + fayanL.mj_h + topSpace
        self.addSubview(courseView)
        self.addSubview(bottomView)
        self.mj_h = bottomView.mj_y + bottomView.mj_h
        
    }
    //MARK: 创建选集按钮
    func createCourseBtns(array:[AnyObject]){
        
        btnW = (SCREEN_W - 2 * leftSpace - 7 * space) / 8
        self.courseArray.addObjectsFromArray(array)
        
        for i in 0...array.count - 1{
            
            let orginX = leftSpace + CGFloat(i % 8) * (btnW + space)
            let orginY = topSpace + CGFloat(i / 8) * (btnW + space) + updateL.mj_y + updateL.mj_h
            let button = UIButton.init(frame: CGRectMake(orginX, orginY, btnW, btnW))
            button.backgroundColor = GRAYCOLOR
            //设置标题
            button.setTitle(String.init(format: "%ld", i + 1), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: #selector(self.courseBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = 100 + i
            courseView.addSubview(button)
            if i == array.count - 1{
                //默认选中最后一集
                button.backgroundColor = UIColor.orangeColor()
                self.selectedIndex = i
            }
        }
        //更新选中的显示内容 
        self.updateCourseShowContent()
        //计算高度
        self.updateFrames()
    }
    //MARK:播放选中的课程视频
    func playTaped()->Void{
        self.delegate?.playCourseAtIndex(self.selectedIndex)
    }
    
    //MARK: 更新显示选集内容
    func updateCourseShowContent(){
        //取出当前选中的课程模型
        let course = self.courseArray[self.selectedIndex] as! CourseModel
        self.dishImageView.sd_setImageWithURL(NSURL.init(string: course.courseImage))
        self.numL.text = "上课人数:\(course.videoWatchcount)"
        self.nameL.text = course.courseName
        self.contentL.text = course.courseSubject
        //选中选集，通知代理对象，请求点赞好友  和 相关课程的数据
        self.delegate?.headerView(self, didSelectedIndex: self.selectedIndex)
    }
    
    //MARK:更新frame
    func updateFrames()
    {
        self.courseView.backgroundColor = UIColor.whiteColor()
        self.bottomView.backgroundColor = UIColor.whiteColor()
        //然后显示详细描述的Label自适应高度
        self.contentL.sizeToFit()
        UIView.animateWithDuration(0.25) { 
         
            if self.isShow {
                //显示
                self.courseView.mj_y = self.contentL.mj_y + self.contentL.mj_h
            }else{
                //隐藏
                self.courseView.mj_y = self.contentL.mj_y
            }
        }
       
        
        //计算第二部分的高度
        
        var line = 0
        if self.courseArray.count % 8 == 0{
            line = self.courseArray.count / 8
        }else{
            line = (self.courseArray.count / 8 ) + 1
        }
        
        //高度计算 
        //1 如果显示 : 根据按钮行数计算高度
        //2.如果隐藏 : line <= 2 还是根据按钮行数计算高度，line > 2,按line = 2 计算
        if !self.courseShow && line > 2{
            line = 2
        }
        UIView.animateWithDuration(0.25) {
            //改变第二部分的高度
            self.courseView.mj_h = self.updateL.mj_y + self.updateL.mj_h + self.topSpace + CGFloat(line - 1) * self.space + CGFloat(line) * self.btnW
            //第三部分
            self.bottomView.mj_y = self.courseView.mj_y + self.courseView.mj_h
            //计算总体HeaderVeiw的高度
            self.mj_h = self.bottomView.mj_y + self.bottomView.mj_h
        
        }
        self.delegate?.headerViewUpdateFrame(self)
        
    }
    
    //显示或隐藏描述内容
    func showOrHiddenContent(button:UIButton){
        self.isShow = !self.isShow
        if self.isShow {
            //显示
            button.setBackgroundImage(UIImage.init(named: "expend_up"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.init(named: "expend_up"), forState: UIControlState.Highlighted)
            
        }else{
            //隐藏
            button.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Highlighted)
        }
        self.updateFrames()
        
        
    }
    //隐藏或显示16之后的选集按钮
    func showOrHiddenCourse(button:UIButton){
        
        self.courseShow = !self.courseShow
        if self.courseShow {
            //显示
            button.setBackgroundImage(UIImage.init(named: "expend_up"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.init(named: "expend_up"), forState: UIControlState.Highlighted)
            
        }else{
            //隐藏
            button.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.init(named: "expend_down"), forState: UIControlState.Highlighted)
        }
        self.updateFrames()
    }
    //选集按钮被点击
    func courseBtnClicked(button:UIButton){
        //取出之前选中的按钮，改变背景颜色
        let preBtn = courseView.viewWithTag(100 + selectedIndex) as! UIButton
        preBtn.backgroundColor = GRAYCOLOR
        
        button.backgroundColor = UIColor.orangeColor()
        selectedIndex = button.tag - 100
        self.updateCourseShowContent()
        self.updateFrames()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- UICollectionView 协议方法
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == friendView{
            return self.friendArray.count
        }
        return relateArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == friendView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendCell", forIndexPath: indexPath) as! FriendCell
            //取出相应的好友模型
            let friend = self.friendArray[indexPath.item] as! FriendModel
            cell.headImge.sd_setImageWithURL(NSURL.init(string: friend.headImg),placeholderImage: UIImage.init(named: "达人"))
            return cell
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RelateCourseCell", forIndexPath: indexPath) as! RelateCourseCell
        //取出相关课程模型
        let relateCourse = self.relateArray[indexPath.item] as! RelateCourse
        cell.dishImage.sd_setImageWithURL(NSURL.init(string: relateCourse.relation.dishesImage))
        cell.dishTitleL.text = relateCourse.relation.dishesTitle
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if collectionView == friendView{
            return CGSizeMake(80, 80)
        }
        return CGSizeMake(150, 195)
    }
    
    
}
