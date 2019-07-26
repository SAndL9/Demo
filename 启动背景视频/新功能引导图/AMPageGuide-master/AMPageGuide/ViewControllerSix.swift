//
//  ViewControllerSix.swift
//  AMPageGuide
//
//  Created by anmeng on 2016/11/1.
//  Copyright © 2016年 anmeng. All rights reserved.
//

import UIKit

class ViewControllerSix: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentedControl.addTarget(self, action: #selector(ViewControllerSix.segmentedControlValueChanged), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + .milliseconds((Int)(0.2*1000)), execute: {
            AMPageGuide.showGuide(for: self, tagString: "DidAppear")
        })
        
    }
    
    func segmentedControlValueChanged() {
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + .milliseconds((Int)(0.2*1000)), execute: {
            AMPageGuide.showGuide(for: self, tagString: "SegmentValueChanged")
        })
    }
    

   
}
