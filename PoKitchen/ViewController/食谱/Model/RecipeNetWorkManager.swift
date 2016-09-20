//
//  RecipeNetWorkManager.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/12.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation


/**网络请求相关的逻辑 ViewModel 界面显示逻辑的处理*/
extension RecipeModel{
    
    //获取食谱模块的首页数据的方法
    class func requestHomeData(callBack:(bannerArray:[AnyObject]?,cateArray:[AnyObject]?,array:[AnyObject]?,error:NSError?)->Void)->Void{
        // methodName=HomeIndex
        BaseRequest.postWithURL(HOME_URL, para: ["methodName":"HomeIndex"]) { (data, error) in
            if error == nil{
                //成功才能解析
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                //取出第二层数据
                let dict = obj["data"] as! NSDictionary
                // 解析显示在轮播视图上的图片地址
                let banner = dict["banner"]!["data"] as![NSDictionary]
                var bannerArray = [String]()
                //遍历数组获取图片地址
                for ban in banner{
                    let image = ban["image"] as! String
                    bannerArray.append(image)
                }
                
                //解析分类
                
                let cateArr = dict["category"]!["data"] as! [AnyObject]

                let cateArray = CategoryModel.arrayOfModelsFromDictionaries(cateArr)
                
                // 解析显示的食谱数组
                
                let arr = dict["data"] as! [NSDictionary]
                // 存放四个分组数组的大数组
                let dataArray =  NSMutableArray()
                
                for dic in  arr{
                    //取出一个分组的所有 食谱字典 数组
                    let recipeArray = dic["data"] as! [AnyObject]
                    //将分组字典转化为模型
                    let models = RecipeModel.arrayOfModelsFromDictionaries(recipeArray)
                    //遍历数组recipeArray 中的所有字典，将字典对应转换为RecipeModel对象，转换过程中会调用init(dictionary dict: [NSObject : AnyObject]!) 方法，对tags_info 进行进一步的解析
                    //添加一个分组的模型数组
                    dataArray.addObject(models)
                }
                
                //回调
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(bannerArray:bannerArray,cateArray:cateArray! as [AnyObject],array:dataArray as [AnyObject],error: nil)
                })
            }else{
                //失败
                dispatch_async(dispatch_get_main_queue(), { 
                    callBack(bannerArray: nil, cateArray: nil,array: nil,error: error)
                })
                
            }
            
        }
    }
    
    class func loadKindWithId(Id:String!,page:NSInteger,callBack:(array:[AnyObject]?,totalCount:NSInteger!,error:NSError?)->Void)->Void
    {
        
        let para = ["page":String(page),"methodName":"HomeSerial","serial_id":Id,"size":"10"]
        
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil
            {
                
                let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let data = dict.objectForKey("data") as! NSDictionary
                let recipeArr = data.objectForKey("data")
                let array = RecipeModel.arrayOfModelsFromDictionaries(recipeArr as! [AnyObject])
                let count = data.objectForKey("total") as! String
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(array: array as [AnyObject],totalCount:NSInteger(count),error:nil)
                })
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(array: nil,totalCount:0,error:error)
                })
            }
            
        }
        
    }
    
    
    class func searchKind(kindId:String!,page:NSInteger,callBack:(array:[AnyObject]?,totalCount:NSInteger?, error:NSError?)->Void)->Void{
        let  para = ["methodName":"CategorySearch","page":String(page),"cat_id":kindId,"type":"1","size":"10"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil
            {
                let str = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                print(str!)
                let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let data = dict.objectForKey("data") as! NSDictionary
                let recipeArr = data.objectForKey("data")
                let array = RecipeModel.arrayOfModelsFromDictionaries(recipeArr as! [AnyObject])
                let count = data.objectForKey("total") as! String
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(array: array as [AnyObject],totalCount:NSInteger(count),error:nil)
                })
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    callBack(array: nil,totalCount:0,error:error)
                })
            }
            
        }
        
    }

    
    
}