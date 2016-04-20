//
//  SlidingTopView.swift
//  Animations_1try
//
//  Created by Nadav Goldstein on 26/03/2016.
//  Copyright © 2016 Nadav Goldstein. All rights reserved.
//

import UIKit

public class SlidingTopView: UIView, UIGestureRecognizerDelegate {
    
    //MARK: vars
    var parent: CGRect
    
    public var PopView: UIView!
    
    public var PopViewFrame: CGRect = CGRectMake(0, 0, 0, 0)
    public var popBarHeight: CGFloat
    
    
    
    public var MainView: UIView!
    
    public var MainViewFrame: CGRect = CGRectMake(0, 0, 0, 0)
    public var mainViewHeight: CGFloat = 0
    
    public let statusBarHeight: CGFloat
    public let navigationBarHeight: CGFloat
    public let totalTopSize: CGFloat
    
    //the state of the slidingPanel, false means its not revealed, and true means it's visible
    public var slidingState: Bool = false
    
    
    //values for the dragging effect
    var DraggingGesture: UIPanGestureRecognizer!
    var lastLocation: CGPoint = CGPointMake(0, 0)
    
    var IsoverflowDrag: Bool = false
    
    //MARK: Constructors
    
    required public init(parent: CGRect, popBarSize: CGFloat = 70, navigationHeight: CGFloat = 0) {
        
        //init the first vars of the class, before the superclass call
        self.parent = parent
        self.popBarHeight = popBarSize
        
        self.statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        self.navigationBarHeight = navigationHeight
        self.totalTopSize = self.popBarHeight + self.statusBarHeight + self.navigationBarHeight
        
        super.init(frame: CGRectMake(0, 0, 0, 0))
        
        //setting the whole view size
        self.frame = CGRectMake(0, -self.parent.height + self.totalTopSize, self.parent.width, self.parent.height)
        
        //set the dragging listener for the whole view, not just the popper!
        DraggingGesture = UIPanGestureRecognizer(target: self, action: #selector(SlidingTopView.onDragEvent(_:)))
        DraggingGesture.delegate = self
        self.addGestureRecognizer(DraggingGesture)
        
        //set the popper and the main views.
//        self.setPopViewFrame()
        self.PopViewFrame = CGRectMake(0, self.frame.height - popBarHeight, self.frame.width, popBarHeight)
        self.setMainViewFrame()
        
        //Just for debugging
        //ColorViews()
        
    }
    
    
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
        
    }

    //MARK: Initailze the popper and the MainView (dynamic support)
    
    public func setMainViewFrame() {
        let topConsider = self.statusBarHeight + self.navigationBarHeight
        self.mainViewHeight = self.frame.height - self.popBarHeight - topConsider
        
        let alignMain: CGFloat = 0
        self.MainViewFrame = CGRectMake(0, topConsider + alignMain, self.frame.width, self.mainViewHeight - alignMain * 2)
    }
    
    public func AddPopView(popView: UIView) {
        if self.PopView != nil {
            self.PopView.removeFromSuperview()
        }
        
        self.PopView = popView
        
        self.PopView.layer.shadowColor = UIColor.blackColor().CGColor
        self.PopView.layer.shadowOpacity = 0.9
        self.PopView.layer.shadowOffset = CGSizeMake(0, 10)
        self.PopView.layer.shadowRadius = 5
        
        PopView.frame = self.PopViewFrame
        self.addSubview(self.PopView)
        
        //Set click event
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SlidingTopView.onClickPopView(_:)))
        self.PopView.addGestureRecognizer(gesture)
    }

    
    public func AddMainView(mainView: UIView) {
        if self.MainView != nil {
            self.MainView.removeFromSuperview()
        }
        
        self.MainView = mainView
        
        self.MainView.frame = self.MainViewFrame
        self.addSubview(self.MainView)
        
        
    }
    
    //MARK: touch events
    
    public func onClickPopView(sender: UITapGestureRecognizer!) {
        //print("call me maybe")
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
            
            let distanceToGroundY = abs(self.frame.origin.y)
            
            if !self.slidingState {
                self.frame.origin.y += distanceToGroundY
            }
            else {
                self.frame.origin.y = -self.frame.height + self.totalTopSize
            }
            
            }, completion: { finished in
                //print("hello world")
                self.slidingState = !self.slidingState
        })
        
    }
    


    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let isChild: Bool = (touch.view?.isKindOfClass(UIButton.self))!
        if isChild {
            return false
        }
        else {
            return true
        }
    }
//
//    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        
//        
//        return false
//    }
    
    
    public func onDragEvent(sender: UIPanGestureRecognizer) {
        if self.DraggingGesture.state == .Ended
        {
            //print("HELLO IM END")
            scrollToEnd()
        }
        else {
            
            //print("still getting herre")
            self.IsoverflowDrag = self.frame.origin.y > 0 || self.frame.origin.y < -self.frame.height + self.totalTopSize
            // print(self.IsoverflowDrag)
            
            // self.IsoverflowDrag = false
            let traslation = self.DraggingGesture.translationInView(self.superview!)
            if self.IsoverflowDrag && false {
                
                let toppest = -self.frame.height + self.totalTopSize
                let IsCloserTop = abs(self.frame.origin.y - toppest) < abs(self.frame.origin.y)
                
                if IsCloserTop || true {
                    lastLocation = self.center
                    self.frame.origin.y = -self.frame.height + self.totalTopSize
                    
                    
                }
                else {
                    //                    self.frame.origin.y = CGPointMake(lastLocation.x, 0)
                }
            }
            else {
                self.IsoverflowDrag = lastLocation.y + traslation.y > self.frame.height/2 || lastLocation.y + traslation.y < (-self.frame.height)/2 + self.totalTopSize
                if !self.IsoverflowDrag {
                    self.center = CGPointMake(lastLocation.x, lastLocation.y + traslation.y)
                }
                else {
                    
                    let toppest = -self.frame.height + self.totalTopSize
                    let IsCloserTop = abs(self.frame.origin.y - toppest) < abs(self.frame.origin.y)
                    
                    if IsCloserTop {
                        self.frame.origin.y = -self.frame.height + self.totalTopSize
                    }
                    else {
                        self.frame.origin.y = 0
                    }
                    
                }
                //                self.center = CGPointMake(lastLocation.x, 30)
                //print(lastLocation.y)
            }
            
            
            
            
        }
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastLocation = self.center
    }
    
    public func scrollToEnd() {
        if !self.IsoverflowDrag || true {
            let viewLocation: CGPoint = self.frame.origin
            //  print(viewLocation.y, (-self.parent.height + self.popBar + self.statusBarHeight))
            
            let distance = abs(-self.parent.height + self.totalTopSize) - abs(viewLocation.y)
            let precentage = abs(-self.parent.height + self.totalTopSize) / 5
            
            //print(distance, precentage, separator: ", precentage is: ", terminator: ".\n")
            
            if !self.slidingState {
                self.slidingState = !(distance >= precentage)
            }
            else {
                self.slidingState = abs(viewLocation.y) >= precentage
            }
            //self.slidingState = !(viewLocation.y >= (-self.parent.height + self.popBar + self.statusBarHeight))
            onClickPopView(nil)
            
            
        }
    }
    
    //MARK: Debugging area
    public func ColorViews(mainColor: String, popperColor: String) {
        self.backgroundColor = UIColor(hex: mainColor)
        self.PopView.backgroundColor = UIColor(hex: popperColor)
        
        
    }
    
    //MARK: page specific
    
    public func SetRedLine() {
        let bottomLine: UIView = UIView()
        bottomLine.backgroundColor = UIColor.redColor()
        bottomLine.frame = CGRectMake(0, self.popBarHeight - 3, self.frame.size.width, 3)
        self.PopView.addSubview(bottomLine)
    }
    
    
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = NSScanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}

