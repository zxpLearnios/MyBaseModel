
//
//  testModel.swift
//  test_baseModel
//
//  Created by Jingnan Zhang on 16/5/24.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  测试MyBaseGrandModel 

import UIKit


struct StructDemo {
    var q = 1
    var w = "w"
}

class ClassDemoA:MyBaseGrandModel{
    var q = 1
    var w = "w"
}

// 核心， 测试用的
class TestModel: MyBaseGrandModel {
    var i:Int = 1 // 不需要写映射表，外部大、小写皆可
    var o:String?
    var classDemoA:ClassDemoA?
    var structDemo:StructDemo?
    var classDemoAArray:[ClassDemoA]?
    var classDemoDict:[String:ClassDemoA]? // 字典的另一写法
    var anyObjectDic:Dictionary<String, Any>? // 字典的新写法
    
    /**  定义一个映射表，Key就是你想要转换的字典的Key，而Value是Model的变量名 */
    static let mapDict =  ["AnyObjectDic_11":"anyObjectDic"]
    
    override  var  selfMapDescription: [String : String]?{
        return TestModel.mapDict
    }
    
}


//  -----------------  ----------------------------------- //
// 测试模型数据按时间进行排序 1.
class TestSortTool: NSObject {
    
    convenience init(dic:String) {
        self.init()
        
        let ary = [["name":"name1", "creatTime":"2015-10-10"],["name":"name2", "creatTime":"2015-04-10"],["name":"name3", "creatTime":"2014-10-10"],["name":"name4", "creatTime":"2014-11-11"]]
        
        var modelAry = TestSortOfModel.getTestSortOfModels(withParams: ary)
        // 1.
//        let newAry = modelAry.sortArrayByDate(modelAry) // 排序
//        for ml in newAry {
//            debugPrint(ml)
//        }
        
        // 2. 按时间先后排序
        modelAry.sort { (ml0, ml1) -> Bool in
            if ml0.creatDate!.isEarlierThanDate(compareToDate: ml1.creatDate!) {
                return true
            }
            return false
            
        }
     debugPrint(modelAry)
        
        // 3.
//        let newAry = modelAry.bubbleSortByDate(modelArray: modelAry)
//        debugPrint(newAry)
        
        
    }
    
        
}

// 测试模型数据按时间进行排序  2.
class TestSortOfModel: MyBaseGrandModel {
    
    var name:String?
    var creatTime:String?
    
    // 外加属性，以便使用
    var creatDate:Date?
    
    class func  getTestSortOfModels(withParams params:[[String:String]]) -> [TestSortOfModel]{
        var ary = [TestSortOfModel]()
        for dic in params {
            let model = TestSortOfModel.init(dic: dic as [String : AnyObject])
            ary.append(model)
        }
        return ary
    }
    
    convenience init(dic:[String:AnyObject]) {
        self.init()
        self.name = dic["name"] as? String
        self.creatTime = dic["creatTime"] as? String
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.creatDate = df.date(from: self.creatTime!)
    }
    
    
    
}

// ----------------------------  扩展  -----------------------------  //
extension Date {
    func  isEarlierThanDate(compareToDate thanDate:Date) -> Bool {
        
        if self.compare(thanDate) == .orderedAscending {
            return true
        }else{
            return false
        }
    }

}

extension Array{
    /**
     1. 排序数组，按时间先后
     */
    func sortArrayByDate(_ array:[TestSortOfModel]) -> [TestSortOfModel] {
        var modelAry = array
        for i in 0..<modelAry.count { // 总的比较（循环）次数
            
            for j in 0 ..< (modelAry.count - 1 - i) { // 每次比较（循环）中共需要比较的次数
                
                let subModel0 = modelAry[j]
                let subModel1 = modelAry[j+1]
                if  subModel0.creatDate!.isEarlierThanDate(compareToDate:subModel1.creatDate!) {
                    
                }else{
                    modelAry[j+1] = subModel0
                    modelAry[j] = subModel1
                }
                
                
            }
            
            
        }
        
        return modelAry
    }
    
    /**
     2. 排序数组，按时间先后
     */
    func bubbleSortByDate(modelArray models: [TestSortOfModel]) -> [TestSortOfModel] {
        var newAry = models
        
        newAry.sort { (ml0, ml1) -> Bool in
            if ml0.creatDate!.isEarlierThanDate(compareToDate: ml1.creatDate!) {
                return true  // 表示排序
            }
            return false
            
        }
        return newAry
        
    }
}
