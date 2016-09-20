//
//  RegistureViewController.swift
//  PokechainDemo
//
//  Created by 夏婷 on 16/7/18.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class RegistureViewController: UIViewController {

    @IBOutlet weak var idefyBtn: UIButton!
    @IBOutlet weak var userField: UITextField!
    
    @IBOutlet weak var idefyCodeFiled: UITextField!
    
    @IBOutlet weak var phoneCodeFiled: UITextField!
    var ssID:String! = ""
    var idfyUrl:String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "loginBackgroundImage.png")!)

        self.userField.backgroundColor = UIColor.clearColor()
        self.idefyCodeFiled.backgroundColor = UIColor.clearColor()
        self.phoneCodeFiled.backgroundColor = UIColor.clearColor()
        //获取默认的验证码信息
        self.updateIdefyCode(self)
    }
    
    //更新图片验证码
    @IBAction func updateIdefyCode(sender: AnyObject) {
        
        // methodName=UserVerify&token=&user_id=&version=4.4
        
        let para = ["methodName":"UserVerify","version":"4.4"]
        
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil {
                
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let msg = obj["msg"] as! String
                if msg == "success"{//进一步判断获取验证码成功
                    let dict = obj["data"] as! NSDictionary
                    
                    let imageUrl = NSString.init(string: dict["image"] as! String)
                    //url中存在{} 两个符号，iOS中的URL是不处理的，需要进行Unicode编码
                    let image = imageUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
                    self.ssID = dict["sessid"] as! String
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                      
                        //设置显示
                        self.idefyBtn.sd_setBackgroundImageWithURL(NSURL.init(string: image!), forState: UIControlState.Normal)
                        self.idefyBtn.sd_setBackgroundImageWithURL(NSURL.init(string: image!), forState: UIControlState.Selected)
                    })
                   
                }
            }else{
                print("获取验证码失败")
            }
        }
        
    }
    
    //要求后台发送短信验证码
    @IBAction func sendPhoneCode(sender: AnyObject) {
        
        //methodName=UserLogin&mobile=18515996749&sessid=%7B01f1b9bc-e990-c1b5-e201-1eed6909f821%7D&token=&user_id=&verify=Yxua&version=4.4
        let para = ["methodName":"UserLogin","mobile":self.userField.text!,"sessid":self.ssID,"verify":self.idefyCodeFiled.text!,"version":"4.4"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil {
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let msg = obj["msg"] as! String
                if msg == "success"{
                    //提示信息
                    let scalar = obj["data"]!["scalar"] as! String
                    let alert = UIAlertController.init(title: "提示", message: scalar, preferredStyle: UIAlertControllerStyle.Alert)
                    dispatch_async(dispatch_get_main_queue(), { 
                        
                        self.presentViewController(alert, animated: false, completion: nil)
                        //延迟两秒消失
                        alert.performSelector(#selector(UIAlertController.dismissViewControllerAnimated(_:completion:)), withObject: nil, afterDelay: 2)
                    })
                }
                
            }else{
                print("发送失败,应该用alert显示出来")
            }
        }
       
    }

    
    @IBAction func nextStop(sender: AnyObject) {
        
        //code=197354&device_id=0819b83fb99&methodName=UserAuth&mobile=18515996749&token=&user_id=&version=4.4
        
        let para = ["code":self.phoneCodeFiled.text!,"methodName":"UserAuth","mobile":self.userField.text!,"version":"4.4"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil {
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let msg = obj["msg"] as! String
                if msg == "success"{
                    
                    //判断用户是否已经注册
                    let isExist = obj["data"]!["pwd_exist"] as! Bool
                    if isExist{
                        print("用户已经存在")
                    }else{
                        //将用户ID 和token取出，传到下一个界面使用
                        let newUser = NewUserController()
                        newUser.userId = NSInteger(obj["data"]!["user_id"] as! NSNumber)
                        newUser.token = obj["data"]!["token"] as! String
                        dispatch_async(dispatch_get_main_queue(), {
                            self.navigationController?.pushViewController(newUser, animated: true)
                        })
                    }
                }
            }

        }
    }

    @IBAction func backtoPreView(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
