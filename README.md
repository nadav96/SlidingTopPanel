# SlidingTopPanel
This library was built because I did not found anything like it in the IOS community (all the 'swipeable' views were refering to the navigation drawer, default from the left, which does not fit my needs, even if it comes from the top, as it doesn't have the draggable functionallty), it's the swift crappy equivlent of [AndroidSlidingUpPanel made by umano](https://github.com/umano/AndroidSlidingUpPanel).

###Carthage

```
github "nadav96/SlidingTopPanel" "master"
```

###Basic usage

The UIView is splited into two main subviews: **PopView** and **MainView**

![alt text](https://raw.githubusercontent.com/nadav96/SlidingTopPanel/master/classifcation.png)


* initialization
```swift
let slider: SlidingTopView = 
    SlidingTopView(parent: self.view.frame, popBarSize: 90, navigationHeight: 
    (self.navigationController?.navigationBar.frame.size.height)!)

let mainContentView: UIView = UIView()
mainContentView.frame = slider.MainViewFrame

let popperView: UIView = UIView()
popperView.frame = slider.PopViewFrame

//Adding the views to the main slider, this is very importent!
slider.AddMainView(mainContentView)
slider.AddPopView(popperView)

//For debugging, color the views:
mainContentView.backgroundColor = UIColor(hex: "#")
popperView.backgroundColor = UIColor(hex: "#")


self.view.addSubView(slider)
```

And that's it, now you have the most basic panel that can slide from the top!


Let's be honest, this is a very very buggy implemention, and because I guess some people would find this UIView useful, I figured, why not work togther to make this as awesome as umano alterntive in the Android world?

So, If you have some time and want to contribute, you are more then welcome to join in! :D

Here is another screenshot of the view in action:
![alt text](https://raw.githubusercontent.com/nadav96/SlidingTopPanel/master/sliderInActopn.png)
