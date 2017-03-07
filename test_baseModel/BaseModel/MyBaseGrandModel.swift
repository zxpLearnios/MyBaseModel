//
//  MyBaseGrandModel.swift
//  test_baseModel
//
//  Created by Jingnan Zhang on 16/5/24.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 基础宏大的model, 这里不定义任何属性，所有用的属性都在子类；2. 让模型有自我描述的能力
//  3. 模型可以直接归档、解档了 
/**
 // 这句是在swift3时新加的，因为此时已大的区别于swift2了
 if properties?.pointee == nil || properties!.pointee?.debugDescription == nil{
 break
 }
 */

import UIKit


@objc class MyBaseGrandModel:NSObject, NSCoding{
    
    // 直接重写2个属性, 只有get
    override var debugDescription: String{
        get{
            return self.description
        }
    }
    
    override var description: String{
        get{
            var dict = [String: AnyObject]()
            let count:UnsafeMutablePointer<UInt32>? = nil // 属性的个数
            var properties = class_copyPropertyList(type(of: self), count) // 所有的属性
            
//            if properties != nil {
//                if properties?.pointee != nil {
//                    if properties?.pointee.debugDescription != nil {
//                        
//                    }
//                }
//
//            }
            while properties?.pointee.debugDescription !=  "0x0000000000000000"{
                
                // 这句是在swift3时新加的，因为此时已大的区别于swift2了
                if properties?.pointee == nil || properties!.pointee?.debugDescription == nil{
                    break
                }
                if let t = property_getName(properties?.pointee) { // 获取属性
                    let n = NSString(cString: t, encoding: String.Encoding.utf8.rawValue)
                    let v = self.value(forKey: n as! String) ?? "nil"
                    dict[n as! String] = v as AnyObject?
                    properties = properties?.successor()
                }
                
            }

            return "\(type(of: self)):\(dict)"
        }
    }
    
    // MARK: 初始化方法, 必须加required
//    required override init() {
//        super.init()
//    }
    var selfMapDescription:[String:String]?{
        get{
            return nil
        }
    }
    
    // 函数
    static var typeMapTable:[String:[String:MyBaseGrandType]] = [String:[String:MyBaseGrandType]]()
    
    required override init() {
        super.init()
        
        let modelName = "\(type(of: self))"
        if type(of: self) == MyBaseGrandType.self
        {
            return
        }
        if !MyBaseGrandModel.typeMapTable.keys.contains(modelName){
            MyBaseGrandModel.typeMapTable[modelName] = [String:MyBaseGrandType]()
        }
        if MyBaseGrandModel.typeMapTable[modelName]!.count != 0{
            return
        }
        
        // Mirror 获取所有属性替代了oc中的Runtime
        let mir = Mirror(reflecting: self)
        for (key,value) in mir.children {
            let grandType = MyBaseGrandType(propertyMirrorType: Mirror(reflecting: value), belongType: type(of: self)) // 有了大神的这个还真是方便多了
            MyBaseGrandModel.typeMapTable[modelName]![key!] = grandType
        }
        
    }


    
    // MARK: 获取所有的属性
    func getSelfProperty()->[String]{ //这里不能用静态方法，因为父类没法获取运行时的子类，只能获取运行时子类的实例
        var selfProperties = [String]()
        let count:UnsafeMutablePointer<UInt32>? =  nil
        var properties = class_copyPropertyList(type(of: self), count)
        while properties?.pointee.debugDescription !=  "0x0000000000000000"{
            if properties?.pointee == nil || properties!.pointee?.debugDescription == nil{
                break
            }
            
            let t = property_getName(properties?.pointee)
            let n = NSString(cString: t!, encoding: String.Encoding.utf8.rawValue)
            selfProperties.append(n! as String)
            properties = properties?.successor()
        }
        return selfProperties
    }
    
    // MARK: -----------------   NSCoding  ---------------- //
    //归档方法
    
    @objc func encode(with aCoder: NSCoder) {
        let item = type(of: self).init()
        let properties = item.getSelfProperty()
        for propertyName in properties{
            let value = self.value(forKey: propertyName)
            aCoder.encode(value, forKey: propertyName)
        }

    }
    
    //解档方法
    @objc required init?(coder aDecoder: NSCoder) {
        super.init()
        let item = type(of: self).init()
        let properties = item.getSelfProperty()
        for propertyName in properties{
            let value = aDecoder.decodeObject(forKey: propertyName)
            self.setValue(value, forKey: propertyName)
        }

    }
    
    // MARK: KVC
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("没有这个字段-------\(key)")
    }
}

/*
 1. Swift的反射可以用在以下场景
 遍历Turple
 对类做分析，获取属性和值
 运行时分析对象的一至性
 
 */
