# AMPageGuide
一个简单易用的功能引导工具，通过绑定控件的tag值定位引导的焦点，通过plist文件进行页面引导的配置

![image](https://raw.githubusercontent.com/teacherAnMeng/AMPageGuide/master/imgs/1.gif)

![image](https://raw.githubusercontent.com/teacherAnMeng/AMPageGuide/master/imgs/2.gif)

![image](https://raw.githubusercontent.com/teacherAnMeng/AMPageGuide/master/imgs/3.gif)

![image](https://raw.githubusercontent.com/teacherAnMeng/AMPageGuide/master/imgs/4.gif)



 AMPageGuide.plist 说明
 {//level1 字典存储一个功能引导
    "功能引导key": [ // 一个功能引导可以由多个引导页组成
       {// 一个引导页的配置描述
          "markViews":[
              {"tag":Number, "aligment":"left"||"right"||"center"},
              ...
          ],
          "titleImages":[
              "image":"xxx.png",
              "xPercent":Number,
              "yPercent":Number,
              "wPercent":Number
          ],
          "buttonPos":[
              "xPercent":Number,
              "yPercent":Number,
              "width":Number,
              "height":Number
          ]
      },
      {
          ...
      }
    ],
    "功能引导key":[
         ...
    ]
    ...
 }


 功能引导key: "页面控制器类名#标示"
 markViews:  需要标记的view数组 配置信息
      tag: view的tag值，需要在代码或interfaceBuilder中设定
      aligment: 标记在view上的对齐位置  左||右||居中
 titleImages: 引导文字图片 配置信息
      image: 图片名，图片放在AMPageGuide中，以便于管理
      xPercent: 图片对象的x值位于屏幕宽度比    0.0~1.0
      yPercent: 图片对象的y值位于屏幕高度比    0.0~1.0
      wPercent: 图片对象的width值位于屏幕宽度比 0.0~1.0
 buttonPos: 完成按钮位置 配置信息
      xPercent: 按钮对象的x值位于屏幕宽度比    0.0~1.0
      yPercent: 按钮对象的y值位于屏幕高度比    0.0~1.0
      width: 按钮的宽度值
      height: 按钮的高度值

