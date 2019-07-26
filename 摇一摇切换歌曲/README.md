# HotTool
摇一摇简单实现
##### 小例子：摇一摇简单实现
- 准备：
>- 先在targets -> Build Phases -> Link Binary With Libraries里面添加AudioToolbox.framework；
   -  >AudioservicesPlaySystemSound函数来播放简单的声音
 1.音频长度小于30秒
 2.格式只能是PCM或者IMA4
 3.文件必须被存储为.caf、.aif、或者.wav格式
 4.简单音频不能从内存播放，而只能是磁盘文件
     - 注意局限性： 无法循环播放声音，也无法控制立体声效果。可以设置一个回调函数，在音频播放结束时被调用，可以对音频对象做清理工作，以及通知你的程序播放结束。 
  - 在模拟器中运行时，可以通过「Hardware」-「Shake Gesture」来测试「摇一摇」功能
