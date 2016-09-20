//
//  CommunityNetworkManager.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/14.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation

extension TopicModel {
    /**请求推荐模块的数据*/
    class func requestCommunityData(callBack:(banner:[AnyObject]?,array:[AnyObject]?,error:NSError?)->Void){
        
        
        // methodName=ShequRecommend&token=&user_id=&version=4.4
        let para = NSMutableDictionary.init(dictionary: ["methodName":"ShequRecommend","version":"4.4"])
        if UserModel.shareUser.isLogin {
            para.setValue(UserModel.shareUser.userID, forKey: "user_id")
            para.setValue(UserModel.shareUser.token, forKey: "token")
        }
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil {
                
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                //解析轮播视图的图片数组
                let imgaes = obj["data"]!["banner"] as? [AnyObject]
                var imageArray = [String]()
                if imgaes?.count > 0{
                    
                    for dic in imgaes!{
                        
                        imageArray.append(dic["banner_picture"] as! String)
                    }
                }
                
                //解析掌厨达人数组
                
                let talents = obj["data"]!["shequ_talent"] as! [AnyObject]
                //转换为模型
                let talentArray = TalentModel.arrayOfModelsFromDictionaries(talents)
                
                //解析精选作品
                let  marrows = obj["data"]!["shequ_marrow"] as! [AnyObject]
                let  marrowArray = MarrowModel.arrayOfModelsFromDictionaries(marrows)
                
                //解析专题模型
                let topics = obj["data"]!["shequ_topics"] as! [AnyObject]
                let topicArray = TopicModel.arrayOfModelsFromDictionaries(topics)
                
                //最后得到的topicArray中，第一个元素是掌厨达人的数组，第二是精选作品的数组，之后的每一个元素都是TopicModel的对象
                
                topicArray.insertObject(marrowArray, atIndex: 0)
                topicArray.insertObject(talentArray, atIndex: 0)
                //回调主线程中刷新UI
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(banner: imageArray,array: topicArray as [AnyObject],error: nil)
                })
                
            }else{
               
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(banner: nil, array: nil,error: error)
                })
            }
        }

        
    }
    
}