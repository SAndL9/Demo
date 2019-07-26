//
//  ViewControllerOne.swift
//  AMPageGuide
//
//  Created by anmeng on 2016/11/1.
//  Copyright © 2016年 anmeng. All rights reserved.
//

import UIKit

class ViewControllerOne: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "单引导页：一个标记view + 引导图片"
        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + .milliseconds((Int)(0.2*1000)), execute: {
            AMPageGuide.showGuide(for: self, tagString: "DidAppear")
        })
    }
    

}











