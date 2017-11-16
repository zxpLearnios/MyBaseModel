//
//  ViewController.swift
//  test_baseModel
//
//  Created by Jingnan Zhang on 16/5/24.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor.red
        
        let modelA = TestModel()
        modelA.classDemoAArray = [ClassDemoA]()
        modelA.classDemoAArray?.append(ClassDemoA())
        modelA.classDemoAArray?.append(ClassDemoA())
       
        modelA.classDemoDict = [String:ClassDemoA]()
        modelA.classDemoDict!["1"] = ClassDemoA()
        modelA.classDemoDict!["2"] = ClassDemoA()
        
        modelA.anyObjectDic = Dictionary<String, Any>()
        modelA.anyObjectDic!["3"] = "随便加的哦"
        
        // 1.
//        debugPrint(modelA)
//        let a = modelA.getSelfProperty()
//        
//        let archiverData = NSKeyedArchiver.archivedData(withRootObject: modelA)
//        let unArchiverData = NSKeyedUnarchiver.unarchiveObject(with: archiverData)
//            as! TestModel
//        
          // 2.  模型的map映射
         var i:Int = 1
        var o:String?
        
        let testObj:[String :Any] = ["I":100, "O":"oooo", "AnyObjectDic_11":["name":"name_11", "age":121]] // anyObiectDic换成其他的都会失败
        let  modelB = TestModel.map(testObj as AnyObject)
        
        debugPrint(modelB)
        // 3.
        let testSort = TestSortTool.init(dic: "")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

