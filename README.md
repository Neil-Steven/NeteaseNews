# NeteaseNews

* 语言：Swift 3.1
* 编译平台：Xcode 8.3.3


这是一个简单的仿网易新闻的demo，由于最近时间比较紧只写了个大概，还有很多细节没有优化到位，因为之前学习Objective-C时几乎没有使用过Storyboard，所以学习Swift时尽可能多的去尝试它，虽然一直到现在它依然不是很完善，但我觉得将代码逻辑与UI设计分开是未来的趋势（主要是我个人不喜欢在代码里看到一堆布局相关的东西，不直观呀）

先实现了一些基本功能，顶部的滚动视图没有写点击进入的详情界面，新闻列表里的一些大图新闻cell也没有写（暂时先报新闻地址获取失败的错，其实是还没实现^_^）不过顶部的滚动视图是自己写的，逻辑不是很复杂，实现了定时滚动和循环滚动，可能还有bug，如果发现希望能跟我交流一下~



**使用的第三方框架：**

* AFNetworking
* MJRefresh
* SDWebImage
* SVProgressHUD



**存在的问题：**

打开新闻详情界面后会在控制台输出一些警告信息：
<img src="https://github.com/Neil-Steven/NeteaseNews/blob/master/Screenshots/Screenshot_Warning.png" width="802" height="329" />

然后苹果官方的回复是不用管它……

> Its not a compiler warning, its an Objective-C runtime warning, and it is not in any code that you control. You can safely ignore it, as you cannot fix it.

好吧，假装它不存在好了 233333


**效果图：**

<img src="https://github.com/Neil-Steven/NeteaseNews/blob/master/Screenshots/Screenshot1.png" width="450" height="800" />  
<img src="https://github.com/Neil-Steven/NeteaseNews/blob/master/Screenshots/Screenshot2.png" width="450" height="800" />