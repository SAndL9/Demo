//
//  AMPGShadowView.swift
//  SSA
//
//  Created by anmeng on 2016/10/31.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit


/// 页面引导 遮盖view
class AMPGShadowView: UIView {
    
    
    /// 引导按钮，next/know，可以指定按钮，也可以使用默认
    lazy var button:UIButton = { ()->UIButton in
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.green
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("我知道了", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    
    /// 图片数据字典数组，[["image":"xxx.png", "rect":CGRect()], [...], ...]
    var imageDatas:[[[String:Any]]]? = nil
    /// 引导按钮的frame
    var buttonRects:[CGRect]? = nil
    
    /// UserDefault字段
    var udKeyString:String? = nil
    
    fileprivate var imageViewArray = Array<UIImageView>()
    
    fileprivate var currentPageIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 在window中显示
    open func showInWindow() {
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(self)
        self.frame = window.bounds
        
        self.currentPageIndex = 0
        self.showSubviews()
    }
    func showSubviews() {
        if self.buttonRects == nil || self.currentPageIndex >= (self.buttonRects?.count)! {
            if self.udKeyString != nil {
                UserDefaults.standard.set("", forKey: self.udKeyString!)
                UserDefaults.standard.synchronize()
            }
            self.removeFromSuperview()
            return
        }
        
        self.showImages()
        self.showButton()
        
        self.currentPageIndex += 1
    }
    func showImages() {
        while self.imageViewArray.count > 0 {
            let iv = self.imageViewArray.last!
            iv.removeFromSuperview()
            self.imageViewArray.removeLast()
        }
        
        
        if self.imageDatas == nil || self.currentPageIndex >= (self.imageDatas?.count)! {
            return
        }
        
        let imgDicts = (self.imageDatas?[self.currentPageIndex])!
        
        for imgDict in imgDicts {
            let img = imgDict["image"] as! UIImage
            let rect = imgDict["rect"] as! CGRect
            
            let imgView = UIImageView(image: img)
            self.addSubview(imgView)
            self.imageViewArray.append(imgView)
            imgView.frame = rect
        }

    }
    
    func showButton() {
        if self.buttonRects == nil || self.currentPageIndex >= (self.buttonRects?.count)! {
            return
        }
        if self.button.superview == nil {
            self.addSubview(self.button)
            button.addTarget(self, action: #selector(AMPGShadowView.showSubviews), for: .touchUpInside)
        }
        
        let btnRect = (self.buttonRects?[self.currentPageIndex])!
        
        self.button.frame = btnRect
    }
    
}








