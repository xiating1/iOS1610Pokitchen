//
//  UserModel.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/13.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit
/**用户信息*/
//声明一个全局的常量，Swift 中的常量时能够保证不再被赋值
let user = UserModel()


class UserModel: JSONModel {
    
    var userID:String! = ""
    var token:String! = ""
    var nickname:String! = ""
    var isLogin = false
    
    class var shareUser:UserModel {
        
        return user
    }
    
}
