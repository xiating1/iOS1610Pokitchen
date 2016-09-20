//
//  DishClassNetworkManger.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/13.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation

extension DishModel{
    
    class func requestCourseData(page:NSInteger,callBack:(dishArray:[AnyObject]?,error:NSError?)->Void){
        
        let para = ["methodName":"CourseIndex","page":String(page),"version":"4.4","size":"10"]
        let para1 = NSMutableDictionary.init(dictionary: para)
        //根据登录状态，增加参数键值对
        if UserModel.shareUser.isLogin{
            para1.setObject(UserModel.shareUser.userID, forKey: "user_id")
            para1.setObject(UserModel.shareUser.token, forKey: "token")
        }
        

        BaseRequest.postWithURL(HOME_URL, para: para1) { (data, error) in
            
            if error == nil {
                
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                //取出食课数组
                let data = obj["data"]!["data"] as! [AnyObject]
                
                var  models = NSMutableArray()
                if data.count > 0 {
                   models = DishModel.arrayOfModelsFromDictionaries(data)
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(dishArray: models as [AnyObject],error: nil)
                })
                
            }else{
                //错误回调
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(dishArray: nil,error: error)
                })
            }
            
        }
    }
}


extension AlbumModel {
    
    /**获取顶端图标数据*/
    class func requestAlbumData(callBack:(array:[AnyObject]?,error:NSError?)->Void){
        //methodName=CourseLogo&token=9B6EF4052641DB78766773995185F896&user_id=947432&version=4.4
        let para = NSMutableDictionary.init(dictionary: ["methodName":"CourseLogo","version":"4.4"])
        
        if UserModel.shareUser.isLogin {
            para.setObject(UserModel.shareUser.userID, forKey: "user_id")
            para.setObject(UserModel.shareUser.token, forKey: "token")
        }
        //发起请求
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil {
                
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let arr = obj["data"]!["albums"] as! [AnyObject]
                var array = NSMutableArray()
                if arr.count > 0 {
                    
                    array = AlbumModel.arrayOfModelsFromDictionaries(arr)
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    
                    callBack(array: array as [AnyObject],error: nil)
                })
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array: nil, error: error)
                })
            }
        }
        
        
    }
    
}

