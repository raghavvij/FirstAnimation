//
//  ExpandableView.swift
//  AnimationAssignment
//
//  Created by raghav vij on 3/6/17.
//  Copyright © 2017 raghav vij. All rights reserved.
//

import UIKit

@IBDesignable class ExpandableView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    @IBInspectable var controlPoint:CGPoint = CGPoint(x:0, y:64)
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: rect.height/2))
        path.addQuadCurve(to: CGPoint(x:rect.size.width, y:rect.height/2), controlPoint: controlPoint)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        UIColor.red.setFill()
        path.fill()
        path.close()
    }
 

}
