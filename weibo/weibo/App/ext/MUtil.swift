//
//  MUtil.swift
//  DLog
//
//  Created by mason on 2017/7/29.
//  Copyright © 2017年 mason. All rights reserved.
//

import Foundation

class MUtil : NSObject {
}

// MARK - 自定义打印-只允许在DEBUG模式下输入打印
func MLog <T>(message : T, file : String = #file, function : String = #function, line : Int = #line) {
    #if DEBUG
        print("\(function)-\(line)：\(message)")
    #endif
}
