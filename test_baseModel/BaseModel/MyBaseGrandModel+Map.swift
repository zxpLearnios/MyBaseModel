//
//  MyBaseGrandModel+Map.swift
//  MyBaseGrandModelDemo
//
//  Created by HuStan on 5/15/16.
//  Copyright © 2016 StanHu. All rights reserved.
//  使用Swift反射  模型的map映射

import Foundation

extension MyBaseGrandModel{
    
    /**
        外部传入字典\数组（里面存放字典），由之实现 字典转模型
     *  使用见viewController
     */
    static func map(_ obj:AnyObject)->Self{
        //  let modelName = "\(self)"
        let model = self.init()
        let modelName = "\(type(of: model))"
        let dictTypes = MyBaseGrandModel.typeMapTable[modelName]
        
        // 1. 若掺入的为字典
        if let dict = obj as? [String:AnyObject]
        {
            for item in dict{
                
                var key = item.0  //如果Server传过来的Key和自己写的key完全是一样的，那么用这个获取key
                if model.selfMapDescription != nil { //如果Server传过来的Key和自己写的key不一样的，那么用这个
                    if model.selfMapDescription![item.0] != nil {
                        key = model.selfMapDescription![item.0]!  //如果Server传过来的Key只有部分是一样的？那么怎么办，不好意思，还是老实地写个映射表吧, 其实这也没问题，那就直接用字典的key就行了，只要是一样的
                    }
                }
                print("key 为\(item.0)将要被设成\(key),其值是 \(item.1)")
                let type = dictTypes![key]
                if type == nil {  //正常这里不会是nil
                    continue
                }
                if item.1 is NSNull {
                    continue
                }
                if type!.isArray{
                    //这里就比较麻烦点
                    if let res = type!.isAggregate(){
                        var arrAggregate = [Any]()
                        if res is Int.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: MyBaseGrandType.BasicType.Int, ins: 0)
                        }else if res is Float.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: MyBaseGrandType.BasicType.Float, ins: 0.0)
                        }else if res is Double.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: MyBaseGrandType.BasicType.Double, ins: 0.0)
                        }else if res is String.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: MyBaseGrandType.BasicType.String, ins: "")
                        }else if res is NSNumber.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: MyBaseGrandType.BasicType.NSNumber, ins: NSNumber())
                        }else{
                            arrAggregate = dict[key] as! [AnyObject]
                        }
                        model.setValue(arrAggregate, forKeyPath: key)
                    }else{
                        let elementModelType =  MyBaseGrandType.makeClass(type!) as! MyBaseGrandModel.Type
                        let dictKeyArr = item.1 as! NSArray
                        var arrM: [MyBaseGrandModel] = []
                        for (_, value) in dictKeyArr.enumerated() {
                            let elementModel = elementModelType.map(value as! NSDictionary)
                            arrM.append(elementModel)
                        }
                        model.setValue(arrM, forKeyPath: key)
                    }
                }
                else if !type!.isReflect {
                    if  type!.typeClass == Bool.self{
                        model.setValue(item.1.boolValue, forKeyPath: key)
                    }else {
                        model.setValue(item.1, forKeyPath: key)
                    }
                    continue
                }
                else {
                    if !(item.1 is NSNull)
                    {
                        let cls = ClassFromString((type?.typeName)!)
                        model.setValue((cls as! MyBaseGrandModel.Type).map(item.1 as! NSDictionary), forKeyPath: key)
                    }
                    continue
                }
            }
        }
        return model
    }
    
    /**
     解析数组， 内部调用了
     
     - parameter arrDict:   <#arrDict description#>
     - parameter basicType: <#basicType description#>
     - parameter ins:       <#ins description#>
     
     - returns: <#return value description#>
     */
    class func parseAggregateArray<T>(_ arrDict: NSArray, basicType: MyBaseGrandType.BasicType, ins: T) -> [T]{
        var intArrM: [T] = []
        if arrDict.count == 0 {return intArrM}
        for (_, value) in arrDict.enumerated() {
            var element: T = ins
            let v = "\(value)"
            if T.self is Int.Type {
                element = Int(Float(v)!) as! T
            }
            else if T.self is Float.Type {element = v.floatValue as! T}
            else if T.self is Double.Type {element = v.doubleValue as! T}
            else if T.self is NSNumber.Type {element = NSNumber(value: v.doubleValue! as Double) as! T}
            else{element = value as! T}
            intArrM.append(element)
        }
        return intArrM
    }
}

