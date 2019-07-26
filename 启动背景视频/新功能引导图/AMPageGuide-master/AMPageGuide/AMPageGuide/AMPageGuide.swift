//
//  AMPageGuide.swift
//  SSA
//
//  Created by anmeng on 2016/10/31.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

// AMPageGuide.plist 说明
// {//level1 字典存储一个功能引导
//    "功能引导key": [ // 一个功能引导可以由多个引导页组成
//       {// 一个引导页的配置描述
//          "markViews":[
//              {"tag":Number, "aligment":"left"||"right"||"center"},
//              ...
//          ],
//          "titleImages":[
//              "image":"xxx.png",
//              "xPercent":Number,
//              "yPercent":Number,
//              "wPercent":Number
//          ],
//          "buttonPos":[
//              "xPercent":Number,
//              "yPercent":Number,
//              "width":Number,
//              "height":Number
//          ]
//      },
//      {
//          ...
//      }
//    ],
//    "功能引导key":[
//         ...
//    ]
//    ...
// }
//
//
// 功能引导key: "页面控制器类名#标示"
// markViews:  需要标记的view数组 配置信息
//      tag: view的tag值，需要在代码或interfaceBuilder中设定
//      aligment: 标记在view上的对齐位置  左||右||居中
// titleImages: 引导文字图片 配置信息
//      image: 图片名，图片放在AMPageGuide中，以便于管理
//      xPercent: 图片对象的x值位于屏幕宽度比    0.0~1.0
//      yPercent: 图片对象的y值位于屏幕高度比    0.0~1.0
//      wPercent: 图片对象的width值位于屏幕宽度比 0.0~1.0
// buttonPos: 完成按钮位置 配置信息
//      xPercent: 按钮对象的x值位于屏幕宽度比    0.0~1.0
//      yPercent: 按钮对象的y值位于屏幕高度比    0.0~1.0
//      width: 按钮的宽度值
//      height: 按钮的高度值


/// 功能引导页
class AMPageGuide: NSObject {
    
    /// 引导页 标记按钮，nil为默认样式
    open static var button:UIButton? = nil
    /// 引导页 标记圆的直径
    open static var markDiameter:CGFloat = 80.0
    /// 引导页 标记圆的borderColor
    open static var markBorderColor:UIColor = UIColor.yellow
    /// 引导页 标记圆的borderWidth
    open static var markBorderWidth:CGFloat = 1.0
    /// 引导页 遮盖颜色
    open static var shadowColor:UIColor = UIColor.gray.withAlphaComponent(0.3)
    
    
    /// 显示功能引导页
    ///
    /// - Parameters:
    ///   - viewController: 页面的控制器对象
    ///   - tagString: 标记字符串，对应plist文件中的key  viewController#tagString
    open class func showGuide(for viewController:UIViewController, tagString:String) {
        let keyStr = "\(NSStringFromClass(viewController.classForCoder))#\(tagString)"
        
        let udKeyStr = "kAMPageGuide_\(keyStr)"
        let flag = UserDefaults.standard.object(forKey: udKeyStr)
        if flag != nil {
            return
        }
        
        let guideArr = self.guideDict?[keyStr]
        if guideArr == nil {
            NSLog("AMPageGuide plist file not found or key not found")
            return
        }
        
        
        
        
        var imgDatas = Array<[[String:Any]]>()
        var buttonRects = Array<CGRect>()
        
        for dict in guideArr! as! [[String:Any]] {
            let markViews = dict["markViews"] as! [[String:Any]]
            let buttonPos = dict["buttonPos"] as! [String:Any]
            let titleImages = dict["titleImages"] as! [String:Any]
            
            //截取标记view的图片
            var imgDicts = self.cutImages(view: viewController.view, markViews: markViews)
            //文字提示图片
            let tImageDict = self.titleImage(imgDict: titleImages)
            if tImageDict != nil {
                imgDicts.append(tImageDict!)
            }
            imgDatas.append(imgDicts)
            buttonRects.append(self.buttonPosition(from: buttonPos))
        }
        
        let shadowView = AMPGShadowView(frame: CGRect.zero)
        shadowView.backgroundColor = self.shadowColor
        shadowView.imageDatas = imgDatas
        shadowView.buttonRects = buttonRects
        shadowView.udKeyString = udKeyStr
        
        if self.button != nil {
            shadowView.button = self.button!
        }
        
        shadowView.showInWindow()
    }
    
    
    fileprivate class func titleImage(imgDict:[String:Any])->[String:Any]? {
        if imgDict.count == 0 {
            return nil
        }
        let imageStr = imgDict["image"] as! String
        let image = UIImage(named: imageStr)
        if image == nil {
            return nil
        }
        let window = UIApplication.shared.keyWindow!
        let x = (imgDict["xPercent"] as! CGFloat) * window.frame.width
        let y = (imgDict["yPercent"] as! CGFloat) * window.frame.height
        let width = (imgDict["wPercent"] as! CGFloat) * window.frame.width
        let height = ((image?.size.height)!/(image?.size.width)!)*width
        
        return ["image":image!, "rect":CGRect(x:x, y:y, width:width, height:height)]
    }
    
    fileprivate class func buttonPosition(from dict:[String:Any])->CGRect {
        let xP = dict["xPercent"] as! CGFloat
        let yP = dict["yPercent"] as! CGFloat
        let w = dict["width"] as! CGFloat
        let h = dict["height"] as! CGFloat
        
        let window = UIApplication.shared.keyWindow!
        
        return CGRect(x: window.frame.width*xP, y: window.frame.height*yP, width: w, height: h)
    }
    
    fileprivate class func cutImages(view:UIView, markViews:[[String:Any]])->[[String:Any]] {
        var retArr = Array<[String:Any]>()
        
        for dict in markViews {
            let tag = dict["tag"]! as! Int
            let aligment = dict["aligment"]! as! String
            let v = view.viewWithTag(tag)
            if v == nil {
                continue
            }
            let window = (v?.window)!
            
            var x:CGFloat=0, y:CGFloat=0, w:CGFloat=self.markDiameter, h:CGFloat = self.markDiameter;
            let vPos = v?.convert((v?.bounds.origin)!, to: window)
            
            if aligment == "left" {
                x = (vPos?.x)!
            } else if aligment == "center" {
                x = (vPos?.x)! + (v?.frame.width)!*0.5 - w*0.5
            } else {
                x = (vPos?.x)! + (v?.frame.width)! - w
            }
            y = (vPos?.y)! + (v?.frame.height)!*0.5 - h*0.5
            
            let imgRect = CGRect(x: x, y: y, width: w, height: h)
            
            //截取图片
            UIGraphicsBeginImageContextWithOptions(imgRect.size, true, 2.0);
            window.drawHierarchy(in: CGRect(x:-x, y:-y, width:window.frame.width, height:window.frame.height), afterScreenUpdates: true)
            
            let img1 = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            let img2 = img1.am_pg_clipImage(borderWidth: self.markBorderWidth, borderColor: self.markBorderColor)
            retArr.append(["image":img2, "rect":imgRect])
        }
        
        
        return retArr
    }

    
    
    fileprivate class var guideDict:[String:Any]?  {
        let path = Bundle.main.path(forResource: "AMPageGuide.plist", ofType: nil)
        if path == nil {
            return nil
        }
        let dict = NSDictionary(contentsOfFile: path!)
        if dict == nil {
            return nil
        }
        return dict! as? [String : Any]
    }
    
}



extension UIImage {
    func am_pg_clipImage(borderWidth:CGFloat, borderColor:UIColor)->UIImage {
        let imageWH = self.size.width
        let ovalWH = imageWH - borderWidth * 2.0
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        let path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:imageWH, height:imageWH))
        borderColor.set()
        path.fill()
        
        let clipPath = UIBezierPath(ovalIn: CGRect(x:borderWidth, y:borderWidth, width:ovalWH, height:ovalWH))
        clipPath.addClip()
        
        self.draw(at: CGPoint(x: 0, y: 0))
        
        let retImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return retImg!
    }
}



