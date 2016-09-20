//
//  LoginViewController.swift
//  PokechainDemo
//
//  Created by 夏婷 on 16/7/18.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "loginBackgroundImage.png")!)
        self.userField.backgroundColor = UIColor.clearColor()
        self.passwordField.backgroundColor = UIColor.clearColor()
        
        self.passwordField.secureTextEntry = true
    }

    @IBAction func backToPreView(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func login(sender: AnyObject) {
        
        //methodName=UserSignin&mobile=18515996749&password=c543bdde17c6bb115b84324ff80aaa70&token=&user_id=&version=4.4
        let para = ["methodName":"UserSignin","mobile":self.userField.text!,"password":self.passwordField.text!.md5,"version":"4.4"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil{
               //登录成功之后，应该存储用户的ID、用户名，token
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let msg = obj["msg"] as! String
                if msg == "success"{
                    //存储用户ID
                    UserModel.shareUser.userID = String (obj["data"]!["user_id"] as! NSNumber)
                    UserModel.shareUser.nickname = obj["data"]!["nickname"] as! String
                    UserModel.shareUser.token = obj["data"]!["token"] as! String
                    UserModel.shareUser.isLogin = true
                }
                
            }else
            {
                
            }
        }
        
        print("登录成功")
        self.navigationController?.popViewControllerAnimated(true)

        
    }
    
   
    @IBAction func registureUser(sender: AnyObject) {
        
        let registureVC = RegistureViewController.init()
        self.navigationController?.pushViewController(registureVC, animated: true)
    }
    
    
    @IBOutlet weak var forgetPassword: UIButton!
    
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
