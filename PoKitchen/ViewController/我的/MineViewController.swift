//
//  MineViewController.swift
//  PokechainDemo
//
//  Created by 夏婷 on 16/6/6.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var headImage :UIImageView! = nil
    var  nickL:UILabel! = nil
     lazy var tableView:UITableView = {
       
        let table = UITableView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: UITableViewStyle.Grouped)
        
        table.showsVerticalScrollIndicator = false
        table.bounces = false
        table.tableHeaderView = self.headerView
        table.delegate = self
        table.dataSource = self
        
        
        return table
    }()
    
    lazy var headerView:UIView = {
        
        let header = UIImageView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 240))

        header.image = UIImage.init(named: "mine2.jpg")
        header.userInteractionEnabled = true
        let setBtn = UIButton.init(frame: CGRectMake(self.view.frame.size.width - 50, 35, 30, 30))
        setBtn.setImage(UIImage.init(named: "configure"), forState: UIControlState.Normal)
        setBtn.setImage(UIImage.init(named: "configure"), forState: UIControlState.Highlighted)
        setBtn.addTarget(self, action: #selector(MineViewController.settingBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        header.addSubview(setBtn)
        let blackView = UIView.init(frame: CGRectMake(0, header.frame.size.height - 100, header.frame.size.width, 100))
        
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0.5
        header.addSubview(blackView)
        
        let imageH:CGFloat = 70
        self.headImage = UIImageView.init(frame: CGRectMake(20, blackView.frame.origin.y - imageH/2, imageH, imageH))
        self.headImage.image = UIImage.init(named: "userHeadImage")
        header.addSubview(self.headImage)
        
        self.nickL = UILabel.init(frame: CGRectMake(imageH/2, imageH + self.headImage.mj_y + 10, self.view.frame.size.width - imageH, 30))
        self.nickL.textColor = UIColor.whiteColor()
        self.nickL.font = UIFont.systemFontOfSize(15)
        self.nickL.text = "每个吃货都是有头脸的，登录"
        header.addSubview(self.nickL)
        return header
    }()
    
  lazy var dataArray: NSMutableArray = {
    
    let path = NSBundle.mainBundle().pathForResource("Mine", ofType: "plist")
    let array = NSMutableArray.init(contentsOfFile: path!)
    
    return array!
    
    }()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.view.addSubview(self.tableView)
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        self.tableView.tableHeaderView = self.headerView
        

    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    
    func settingBtnClicked(button:UIButton)->Void
    {
        let loginVC = LoginViewController.init()
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UITableView协议方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let array = self.dataArray.objectAtIndex(section) as! NSArray
        
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "Identify"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil
        {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
            cell?.textLabel?.textColor = UIColor.blackColor()
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textLabel?.font = UIFont.systemFontOfSize(15)
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        let array = self.dataArray.objectAtIndex(indexPath.section) as! NSArray
        cell?.textLabel?.text = array.objectAtIndex(indexPath.row) as? String
        
        if indexPath.section == 1 && indexPath.row == 1
        {
            let hotPack = UIImageView.init(frame: CGRectMake(self.view.frame.size.width - 100, 0, 75, 50))
            hotPack.image = UIImage.init(named: "hotpack.jpg")
            cell?.contentView .addSubview(hotPack)
        }
        if indexPath.section == 2 && indexPath.row == 0
        {
            cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()

            cell?.detailTextLabel?.text = "登录后可查看视频"
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(14)

        }
        return cell!
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    //组头视图的高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 9
    }
    //组尾视图的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  view = UIView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 5))
        view.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
//        view.backgroundColor = UIColor.redColor()
        return view
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let  view = UIView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 1))
        view.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        return view
    }
    

    
 

}
