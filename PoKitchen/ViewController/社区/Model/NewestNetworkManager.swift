//
//  NewestNetworkManager.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/17.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation

//MARK:-最新界面的网络请求

extension NewestDish{
    
    class func getNewestDishes(page:NSInteger!,callBack:(array:NSMutableArray?,error:NSError?)->Void)->Void
    {
        let para = ["methodName":"ShequList","version":"4.4","page":String(page),"size":"10"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil
            {
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                let dict = obj.objectForKey("data") as! NSDictionary
                
                //                print(dict)
                
                let dataArray = dict.objectForKey("data") as! [AnyObject]
                let array = NewestDish.arrayOfModelsFromDictionaries(dataArray)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(array: array,error: nil)
                    
                })
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    callBack(array: nil,error: error)
                })
            }
        }
    }
}
