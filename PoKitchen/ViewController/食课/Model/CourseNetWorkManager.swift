//
//  CourseNetWorkManager.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/18.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation


extension CommentModel{
    //MARK:- 评论网络请求
    class func requestCommentData(relateId:String!,callBack:(array:[AnyObject]?,error:NSError?)->Void){
        
        //methodName=CommentList&page=1&relate_id=60&size=10&token=9B6EF4052641DB78766773995185F896&type=2&user_id=947432&version=4.4
        let para = ["methodName":"CommentList","page":"1","size":"99999","relate_id":relateId,"type":"2","version":"4.4"]
        let para1 = NSMutableDictionary.init(dictionary: para)
        if UserModel.shareUser.isLogin{
            para1.setValue(UserModel.shareUser.userID, forKey: "user_id")
            para1.setValue(UserModel.shareUser.token, forKey: "token")
        }
        BaseRequest.postWithURL(HOME_URL, para: para1) { (data, error) in
            
            if error == nil{
                //成功
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                //解析所有的评论或回复评论
                let array = obj["data"]!["data"] as? [AnyObject]
                var models:NSMutableArray? = nil
                do{
                    models = try CommentModel.arrayOfModelsFromDictionaries(array,error: ())
                }catch{
                    
                   models = NSMutableArray()
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array: models! as [AnyObject],error: nil)
                })
            }else{
                
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array: nil,error: error)
                })
            }
            
        }
    }
    //VM 中的显示逻辑 
    
    var atrr:NSMutableAttributedString{
        
        //内容
        let content:NSMutableString = NSMutableString.init(string: "")
        //文字颜色不同，只能用富文本
        var attr:NSMutableAttributedString? = nil
        if self.parents?.count > 0 {
            let parent = self.parents!.lastObject as! CommentModel
            //回复其他人
            content.appendFormat("回复 %@ : %@", parent.nick,self.content)
            //设置被回复的人的名字为橘黄色
            attr = NSMutableAttributedString.init(string: content as String)
            //查找名字并设置颜色
            attr?.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(15),NSForegroundColorAttributeName:UIColor.orangeColor()], range: content.rangeOfString(parent.nick))
            
        }else{
            //直接评论
            content.appendString(self.content)
            attr = NSMutableAttributedString.init(string: content as String)
        }
        return attr!
    }
    var cellHeight:CGFloat{
        
        let str = NSString.init(string: self.atrr.string)
        let rect = str.boundingRectWithSize(CGSizeMake(SCREEN_W - 128, 9999), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil)
        return rect.height + 70
    }
}
/**获取课程选集详情数据*/
extension CourseModel{
    
    
    class func requestCourseData(relateId:String!,callBack:(model:SeriesModel?,array:[AnyObject]?,error:NSError?)->Void){
        
        //methodName=CourseSeriesView&series_id=60&token=9B6EF4052641DB78766773995185F896&user_id=947432&version=4
        let para = ["methodName":"CourseSeriesView","series_id":relateId,"version":"4.4"]
        let para1 = NSMutableDictionary.init(dictionary: para)
        if UserModel.shareUser.isLogin{
            para1.setObject(UserModel.shareUser.userID, forKey: "user_id")
            para1.setObject(UserModel.shareUser.token, forKey: "token")
        }
        BaseRequest.postWithURL(HOME_URL, para: para1) { (data, error) in
            
            if error == nil{
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let dict = obj["data"] as! NSDictionary
                //将字典转化为模型数组
                let models = SeriesModel.arrayOfModelsFromDictionaries([dict])
                //取出要返回的模型
                let seriesM = models.lastObject as! SeriesModel
                // 解析选集数据
                let array = obj["data"]!["data"] as! [AnyObject]
                let course = CourseModel.arrayOfModelsFromDictionaries(array)
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(model: seriesM,array: course as [AnyObject],error: nil)
                })
                
            }else{
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(model: nil,array: nil, error: error)
                })
            }
        }
    }
    
}

extension FriendModel {
    /**获取点赞好友的网络请求*/
    class func requestFriendData(courseId:String,callBack:(array:[AnyObject]?,error:NSError?)->Void){
        
        //media_type=3&methodName=DianzanList&page=1&post_id=663&size=7&token=9B6EF4052641DB78766773995185F896&user_id=947432&version=4.4
        let para = NSMutableDictionary.init(dictionary: ["media_type":"3","methodName":"DianzanList","page":"1","post_id":courseId,"size":"20","version":"4.4"])
        if UserModel.shareUser.isLogin {
            para.setObject(UserModel.shareUser.userID, forKey: "user_id")
            para.setObject(UserModel.shareUser.token, forKey: "token")
        }
        
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
        
            if error == nil{
               let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let arr = obj["data"]!["data"] as? [AnyObject]
                var models : NSMutableArray? = nil
                do{
                    models = try FriendModel.arrayOfModelsFromDictionaries(arr, error: ())
                }catch{
                    models = NSMutableArray()
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array: models! as [AnyObject],error: nil)
                })
                
            }else{
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array: nil,error: error)
                })
            }
            
        }

    }
}

extension RelateCourse{
    /**相关课程数据请求*/
    class func requestRelateCourseData(courseId:String,callBack:(array:[AnyObject]?,error:NSError?)->Void){
        //course_id=851&methodName=CourseRelate&page=1&size=10&token=&user_id=&version=4.4
        let para = NSMutableDictionary.init(dictionary: ["course_id":courseId,"methodName":"CourseRelate","page":"1","size":"10","version":"4.4"])
        if UserModel.shareUser.isLogin{
            para.setObject(UserModel.shareUser.userID, forKey: "user_id")
            para.setObject(UserModel.shareUser.token, forKey: "token")
        }
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil{
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let array = obj["data"]!["data"] as? [AnyObject]
                var models: NSMutableArray? = nil
                do{
                    models = try RelateCourse.arrayOfModelsFromDictionaries(array, error: ())
                }catch{
                    models = NSMutableArray()
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array: models! as [AnyObject],error: nil)
                })
                
            }else{
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(array: nil,error: error)
                })
            }
        }
    }
    
}
