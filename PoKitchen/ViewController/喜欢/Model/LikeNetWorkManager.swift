//
//  LikeNetWorkManager.swift
//  PokechainDemo
//
//  Created by 夏婷 on 16/7/14.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

/**喜欢模块的网络请求管理*/
extension LikeModel{
    
    class func requestLikeModels(page:NSInteger!,callBack:(likeArray:[AnyObject]?,totalCount:NSInteger?,error:NSError?)->Void)->Void
    {
        let para = ["methodName":"UserLikes","page":String(page),"size":"10","version":"4.32"]
        BaseRequest.getWithURL(HOME_URL, para:  para) { (data, error) in
            if error == nil
            {
                let dict = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                //字典
                let obj = dict.objectForKey("data")
                //存放喜欢的菜谱模型
                let dArray = obj?.objectForKey("data")
                
                let modelArray = LikeModel.arrayOfModelsFromDictionaries(dArray as! [AnyObject])
                
                let count = NSInteger((obj!.objectForKey("count") as? String)!)

                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(likeArray: modelArray as [AnyObject],totalCount: count,error: nil)
                })
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    callBack(likeArray: nil,totalCount: 0,error: error)
                })
            }
            
        }
        
    }
    
    
}
