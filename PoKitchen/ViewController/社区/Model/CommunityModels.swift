//
//  CommunityModels.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/14.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation

/**精选作品模型*/
class MarrowModel: JSONModel {
    
    var content:String!
    var Description:String!
    var id:String!
    var image:String!
    var video:String!
    
    override class func keyMapper()->JSONKeyMapper{
        
        return JSONKeyMapper.init(modelToJSONDictionary: ["Description":"description"])
        //特殊处理某一个字段 ，模型中的属性 和字典中的 key 不一致时，设置赋值对应关系，模型中的属性名作为键,字典中的key 作为 value
    }
}

/**掌厨达人模型*/
class TalentModel: JSONModel {
    
    var beFollow:String!
    var headImg:String!
    var istalent:String!
    var nick:String!
    var tongjiBeFollow:String!
    var userId:String!
    
    override class func keyMapper()->JSONKeyMapper{
        
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
}

/**专题模型*/
class TopicModel: JSONModel {
  
    var id :String!
    var data:NSMutableArray?
    var topicName:String!
    
    required init(dictionary dict: [NSObject : AnyObject]!) throws {
        super.init()
        self.id = dict["id"] as! String
        self.topicName = dict["topic_name"] as! String
        let array = dict["data"] as! [AnyObject]
        self.data = TopicDishModel.arrayOfModelsFromDictionaries(array)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(data: NSData!) throws {
        fatalError("init(data:) has not been implemented")
    }
}

/**专题中的小模型*/
class TopicDishModel: JSONModel {
    
    var id:String!
    var image:String!
    var userId:String!
    var video:String!
    //字典key的个数和模型的属性个数不一致，需要实现这个方法，忽视掉未定义的字段赋值
    override class func propertyIsOptional(propertyName:String)->Bool{
        
        return true
    }
    override class func keyMapper()->JSONKeyMapper{
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
    
    
}

