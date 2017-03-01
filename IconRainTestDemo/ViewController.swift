//
//  ViewController.swift
//  IconRainTestDemo
//
//  Created by 曹小猿 on 16/11/1.
//  Copyright © 2016年 曹小猿. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var startBTn: UIButton!
    @IBOutlet weak var endButton: UIButton!
    
    var timer:NSTimer = NSTimer.init()//定时器
    var moveLayer :CALayer = CALayer.init()//动画layer
    var bgView:UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView.frame = self.view.bounds
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(self.click))
        bgView.addGestureRecognizer(tap)
        self.view.addSubview(bgView)
        
        self.view.bringSubviewToFront(startBTn)
        self.view.bringSubviewToFront(endButton)
    }

    func click(tapgesture:UITapGestureRecognizer) -> Void {
        let touchPoint = tapgesture.locationInView(bgView)
        
        if let sublayers = bgView.layer.sublayers {
            for e in sublayers.enumerate() {
                if (e.element.presentationLayer()!.hitTest(touchPoint) != nil) {
                    print("点中了第\(e.index)个元素")
                    print(e.element.presentationLayer()!.frame)
                    
                    let imageV = UIImageView.init()
                    imageV.image = UIImage.init(named: "x")
                    imageV.frame = e.element.presentationLayer()!.frame
                    self.view.addSubview(imageV)
                    self.view.bringSubviewToFront(imageV)
                    self.endAction(NSNull)
                    break
                }
            }
        }
    }

    @IBAction func beginAction(sender: AnyObject) {
        //防止timer重复添加
        self.timer.invalidate()
        
        self.timer =  NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.showRain), userInfo: "", repeats: true)
        
    }
    
    
    func showRain(){
        
        //创建画布
        let imageV = UIImageView.init()
        imageV.image = UIImage.init(named: "x")
        imageV.frame = CGRect.init(x: 0, y: 0, width: 140, height: 140)
        //这里把这句消除动画有问题
        self.moveLayer = CALayer.init()
        self.moveLayer.bounds = (imageV.frame)
        self.moveLayer.anchorPoint = CGPointMake(0,0)
        //此处y值需比layer的height大
        self.moveLayer.position = CGPointMake(0,-140)
        self.moveLayer.contents = imageV.image!.CGImage
        
        bgView.layer.addSublayer(self.moveLayer)
        //画布动画
        self.addAnimation()
        
    }
    
    //给画布添加动画
    func addAnimation() {
        //此处keyPath为CALayer的属性
        let  moveAnimation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath:"position")
        //动画路线，一个数组里有多个轨迹点
        moveAnimation.values = [NSValue.init(CGPoint: CGPointMake(CGFloat(Float(arc4random_uniform(320))), 10)),NSValue.init(CGPoint: CGPointMake(CGFloat(Float(arc4random_uniform(320))), 500))]
        //动画间隔
        moveAnimation.duration = 5
        //重复次数
        moveAnimation.repeatCount = 1
        //动画的速度
        moveAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        self.moveLayer.addAnimation(moveAnimation, forKey: "move")
    }
    
    @IBAction func endAction(sender: AnyObject) {
        
        self.timer.invalidate()
        //停止所有layer的动画
        
        if let sublayers = bgView.layer.sublayers {
            for item in sublayers {
                item.removeAllAnimations()
                item.removeFromSuperlayer()
            }
        }
    }

}

