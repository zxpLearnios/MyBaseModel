//
//  NSDictionary+extension.swift
//  test_baseModel
//
//  Created by Jingnan Zhang on 16/5/24.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  以便直接输出汉字, 事实证明此法没用

import UIKit

//extension NSDictionary {
//    
//     func descriptionWithLocale(locale: AnyObject?) -> String {
//        super.descriptionWithLocale(locale)
//        
//        let  string = NSMutableString.init()
//        // 开头有个{
//        string.stringByAppendingString("{\n")
//        
//        // 遍历所有的键值对
//        self.enumerateKeysAndObjectsUsingBlock { (key:AnyObject, obj:AnyObject, stop:UnsafeMutablePointer<ObjCBool>) in
//            string.appendString("\t\(key)")
//            string.appendString(" : ")
//            string.appendString("\(obj),\n")
//            
//        }
//        // 结尾有个}
//        string.appendString("}")
//        
//        
//        // 查找最后一个逗号
//        let range = string.rangeOfString(",", options: .BackwardsSearch)
//        if range.location != NSNotFound {
//            string.deleteCharactersInRange(range)
//        }
//        return string as String
//        
//    }
//
//   
//}




//extension NSMutableArray {
//    override public func descriptionWithLocale(locale: AnyObject?) -> String {
////        super.descriptionWithLocale(locale)
//        
//        let  string = NSMutableString.init()
//        
//        // 开头有个{
//        string.stringByAppendingString("[\n")
//        
//        // 遍历所有的元素
//        self.enumerateObjectsUsingBlock { (key:AnyObject, obj:Int, stop:UnsafeMutablePointer<ObjCBool>) in
//            string.appendString("\t\(obj),\n")
//        }
//        
//        // 结尾有个}
//        string.appendString("]")
//        
//        
//        // 查找最后一个逗号
//        let range = string.rangeOfString(",", options: .BackwardsSearch)
//        if range.location != NSNotFound {
//            string.deleteCharactersInRange(range)
//        }
//        return string as String
//    }
//
//}