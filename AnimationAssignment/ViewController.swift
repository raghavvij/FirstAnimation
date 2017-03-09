//
//  ViewController.swift
//  AnimationAssignment
//
//  Created by raghav vij on 3/6/17.
//  Copyright © 2017 raghav vij. All rights reserved.
//

import UIKit

let MinHeight:CGFloat = 128.0
let MaxHeight:CGFloat = (UIScreen.main.bounds.height * 2) - 64

class ViewController: UIViewController {
    
    @IBOutlet weak var panView: ExpandableView!
    var previousPointInSuperView:CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Pan Gesture
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        let expandableView = (sender.view as! ExpandableView)
        let currentPointInPanView:CGPoint = sender.location(in: expandableView)
        let currentPointInSuperView:CGPoint = sender.location(in: self.view)
        let velocityInPanView:CGPoint = sender.velocity(in: expandableView)
        if sender.state == .ended {
            //Ripple Effect logic...
            previousPointInSuperView = nil
            if velocityInPanView.y <= 0 &&  currentPointInPanView.y < (expandableView.frame.size.height)/2{
                let shapeLayer = CAShapeLayer()
                shapeLayer.fillColor = UIColor.red.cgColor
                let basicAnimation = CABasicAnimation(keyPath: "path")
                let initialControlPoint = currentPointInPanView
                let finalControlPoint = CGPoint(x: (expandableView.frame.size.width)/2, y: (expandableView.frame.size.height)/2)
                basicAnimation.fromValue = expandableView.setupPathForView(forControlPoint: initialControlPoint, andRect: expandableView.frame).cgPath
                basicAnimation.toValue = expandableView.setupPathForView(forControlPoint: finalControlPoint, andRect: expandableView.frame).cgPath
                basicAnimation.duration = 0.3
                shapeLayer.add(basicAnimation, forKey: "animationKey")
                expandableView.layer.addSublayer(shapeLayer)
                expandableView.controlPoint = finalControlPoint
                expandableView.setNeedsDisplay()
            }else {
                self.setEndedPanState(forView: expandableView, currentPositionInPanView: currentPointInPanView, currentPositionInSuperView: currentPointInSuperView, velocityInPanView: velocityInPanView)
            }
        }else {
            //When pan gesture is active....
            self.setActivePanState(forView: expandableView, currentPositionInPanView: currentPointInPanView, currentPositionInSuperView: currentPointInSuperView, velocityInPanView: velocityInPanView)
        }
    }
    
    // MARK:- Setup View
    
    func setEndedPanState(forView expandableView:ExpandableView,currentPositionInPanView currentPointInPanView:CGPoint,currentPositionInSuperView currentPointInSuperView:CGPoint,velocityInPanView velocity:CGPoint) {
        previousPointInSuperView = nil
        let controlPoint = CGPoint(x: (expandableView.frame.size.width)/2, y: (expandableView.frame.size.height)/2)
        self.setupExpandableView(ForcontrolPoint: controlPoint, forView: expandableView)
    }
    
    func setActivePanState(forView expandableView:ExpandableView,currentPositionInPanView currentPointInPanView:CGPoint,currentPositionInSuperView currentPointInSuperView:CGPoint,velocityInPanView velocity:CGPoint) {
        var controlPoint = CGPoint(x: (expandableView.frame.size.width)/2, y: (expandableView.frame.size.height)/2)
        if velocity.y > 0 {
            //Animation for downward pan gesture
            if currentPointInPanView.y < (expandableView.frame.size.height)/2 {
                //if current point's y position in pan view is less than half the height of the view.
                self.setupFrame(forView: expandableView,currentPositionInSuperView: currentPointInSuperView, isHeightIncreasing: false, controlPointInPanView: controlPoint)
            }else{
                //This section executes as soon as the current position of gesture is greater than half the height of the frame of panView.
                self.setupFrame(forView: expandableView,currentPositionInSuperView: currentPointInSuperView, isHeightIncreasing: false, controlPointInPanView: controlPoint)
            }
        }else {
            //Animation for upward pan gesture
            //We simply have to decrease the height of the pan view in this case.
            if velocity.y != 0 {
                if currentPointInPanView.y > (expandableView.frame.size.height)/2 {
                    //if current point's y position in pan view is less than half the height of the view.
                    self.setupFrame(forView: expandableView, currentPositionInSuperView: currentPointInSuperView, isHeightIncreasing: true, controlPointInPanView: controlPoint)
                }else {
                    controlPoint = currentPointInPanView
                    self.setupFrame(forView: expandableView, currentPositionInSuperView: currentPointInSuperView, isHeightIncreasing: true, controlPointInPanView: controlPoint)
                }
            }else {
                if currentPointInPanView.y > (expandableView.frame.size.height)/2 {
                    self.setupFrame(forView: expandableView, currentPositionInSuperView: currentPointInSuperView, isHeightIncreasing: true, controlPointInPanView: controlPoint)
                }else {
                    controlPoint = currentPointInPanView
                    self.setupFrame(forView: expandableView, currentPositionInSuperView: currentPointInSuperView, isHeightIncreasing: true, controlPointInPanView: controlPoint)
                }
                
            }
        }
        previousPointInSuperView = currentPointInSuperView
    }
    
    func setupFrame(forView expandableView:ExpandableView,currentPositionInSuperView currentPointInSuperView:CGPoint, isHeightIncreasing isIncreasing:Bool, controlPointInPanView controlPoint:CGPoint) {
        var rect = expandableView.frame
        if isIncreasing {
            if let previousPoint = previousPointInSuperView {
                self.setupExpandableView(ForcontrolPoint: controlPoint, forView: expandableView)
                let changeInY = abs(previousPoint.y - currentPointInSuperView.y)
                let height = rect.height + changeInY
                let originY = rect.origin.y - changeInY
                if height < MaxHeight {
                    let frame = CGRect(x: (rect.origin.x), y: originY, width: (rect.size.width), height: height)
                    self.setupFrame(ForView: expandableView, withFrame: frame)
                    expandableView.setNeedsDisplay()
                    rect = expandableView.frame
                }
            }
        }else {
            if let previousPoint = previousPointInSuperView {
                self.setupExpandableView(ForcontrolPoint: controlPoint, forView: expandableView)
                let changeInY = abs(previousPoint.y - currentPointInSuperView.y)
                let height = rect.height - changeInY
                let originY = rect.origin.y + changeInY
                if height > MinHeight {
                    let frame = CGRect(x: (rect.origin.x), y: originY, width: (rect.size.width), height: height)
                    self.setupFrame(ForView: expandableView, withFrame: frame)
                    expandableView.setNeedsDisplay()
                    rect = expandableView.frame
                }
            }
        }
    }
    
    
    func setupFrame(ForView view:ExpandableView, withFrame frame:CGRect) {
        view.frame = frame
    }
    
    func setupExpandableView(ForcontrolPoint controlPoint:CGPoint,forView view:ExpandableView) {
        view.controlPoint = controlPoint
        view.setNeedsDisplay()
    }
}

