//
//  NewUserController.swift
//  PokechainDemo
//
//  Created by 夏婷 on 16/7/18.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class NewUserController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var passAginField: UITextField!
    
    @IBOutlet weak var nickField: UITextField!
    
    var token:String! = ""
    var userId:NSInteger! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "loginBackgroundImage.png")!)
        self.passwordField.backgroundColor = UIColor.clearColor()

        self.passAginField.backgroundColor = UIColor.clearColor()
        
        self.nickField.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func newUser(sender: AnyObject) {
      
        //methodName=UserPwd&nickname=%E5%A4%A9%E5%A4%A9&password=9f23c3eda1dc8b997f9e5bfb161ef505&token=A2C6B6BE68EB24428D598B299FD15DAC&user_id=1601836&version=4.4
        let para = ["methodName":"UserPwd","nickname":self.nickField.text!,"password":self.passwordField.text!.md5,"user_id":String(self.userId),"version":"4.4","token":self.token]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil {
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let msg = obj["msg"] as! String
                if msg == "success" {
                    //注册成功，返回到登录界面
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
                    })
                }
            }
        }
        print("操作成功,去登录吧")
    }
    
    @IBAction func backPreView(sender: AnyObject) {
        
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
