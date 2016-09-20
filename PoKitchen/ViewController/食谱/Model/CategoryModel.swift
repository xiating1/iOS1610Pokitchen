//
//  CategoryModel.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/12.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

//分类模型
class CategoryModel: JSONModel {
    var id :String!
    var image :String!
    var text:String!

}

//菜谱模型
class RecipeModel: JSONModel {
    
    var content : String!
    var Description : String!
    var id : String!
    var image:String!
    var tagsInfo:NSMutableArray?//存放另外一个模型
    var title:String!
    var video:String!
    var video1:String!
    // 属性和字典中的key 不一一对应，需要实现这个函数，否则会崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    //初始化模型对象时会调用的方法
    required init(dictionary dict: [NSObject : AnyObject]!) throws {
        super.init()
        //借用KVC给属性赋值赋值
        self.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
        
        let array = dict["tags_info"] as? [AnyObject]
        
        if array?.count > 0{
            //将数组中的字典转成模型
            self.tagsInfo = try?TagInfoModel.arrayOfModelsFromDictionaries(array)
            // 这个方法实际上就是遍历数组，根据字典一一创建TagInfoModel的实例对象，并使用字典按照KVC的方式给模型赋值
            
        }
    }
    
    required init(data: NSData!) throws {
        try!super.init(data: data)
        fatalError("init(data:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class TagInfoModel: JSONModel {
    
    var id : String!
    var text : String!
    var type: String!
    
}


