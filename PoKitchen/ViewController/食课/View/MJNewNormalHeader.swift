//
//  MJNewNormalHeader.swift
//  PoKitchen
//
//  Created by 夏婷 on 16/9/13.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class MJNewNormalHeader: MJRefreshNormalHeader {

    //修改下拉刷新的header的显示位置
    override func placeSubviews() {
        super.placeSubviews()
        self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop - 80;

    }

}
