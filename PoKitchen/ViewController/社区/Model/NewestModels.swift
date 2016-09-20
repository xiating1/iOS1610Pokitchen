//
//  NewestModels.swift
//  PokechainDemo
//
//  Created by 夏婷 on 16/7/17.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

/**社区模块最新模块*/
class NewestDish: JSONModel {
    
    var content:String!
    var createTime:String!
    var headImg:String!
    var id:String!
    var image:String!
    var nick:String!
    var agreeCount:String! = ""
    
    override class func propertyIsOptional(property:String)->Bool
    {
        return true
    }
    override class func keyMapper()->JSONKeyMapper
    {
        return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase()
    }
    
}
