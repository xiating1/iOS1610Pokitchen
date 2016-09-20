//
//  DishClasModels.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/13.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import Foundation

class AlbumModel: JSONModel {
    
    var album:String!
    var albumLogo:String!
    var chargeCount:String!
    var seriesId:String!
    
    //JSONModel 提供的编码转换方法，如果字典中的key 为 aa_bb 形式，而iOS中变量命名方式aaBb
    override class func keyMapper()->JSONKeyMapper{
        
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
    //当字典中的key 的个数和 模型属性的个数不完全匹配时，需要实现下面这个方法，并且返回 true ，这样才能保证 将字典中的值赋给相应的属性
    override class func propertyIsOptional(propertyName:String)->Bool{
        return true
    }
    
    
}

class DishModel: JSONModel {
    
    var album:String!
    var albumLogo:String!
    var chargeCount:String!
    var episode:String!
    var episodeSum:String!
    var image:String!
    var play:String!
    var seriesId:String!
    var seriesName:String!
    var tag:String!
    //编码格式转换 将aa_bb 转换为 aaBB
    override class func keyMapper()->JSONKeyMapper{
        
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
}

