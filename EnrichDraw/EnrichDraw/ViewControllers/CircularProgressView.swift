//
//  CircularProgressView.swift
//  DentiCare_iOS
//
//  Created by Mayank IDEAQU on 20/04/20.
//  Copyright © 2020 Mayank IDEAQU. All rights reserved.
//

import UIKit
import Foundation

class CircularProgressView: UIView {
    
    // First create two layer properties
    public var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createCircularPath(value: Double) {
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 40, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .butt
        circleLayer.lineWidth = 7.0
        circleLayer.strokeColor = UIColor(rgb: 0xFBC244).cgColor
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 7.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor(rgb: 0xFF933B).cgColor
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
        
    }
    func progressAnimation(_ duration: TimeInterval, _ toValue:Float) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = toValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    var loadingvalue: CGFloat = 0.0 {
        didSet {
            self.loadingvalue = max(0, min(loadingvalue, 0.99))
        }
    }
    
    private func createCircularLayer(strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
      
      let startAngle = -CGFloat.pi / 2
      let endAngle = 2 * CGFloat.pi + startAngle
      
      let width = frame.size.width
      let height = frame.size.height
      
      let center = CGPoint(x: width / 2, y: height / 2)
      let radius = (min(width, height) - lineWidth) / 2
      
      let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
      
      let shapeLayer = CAShapeLayer()
      
      shapeLayer.path = circularPath.cgPath
      
      shapeLayer.strokeColor = strokeColor
      shapeLayer.lineWidth = lineWidth
      shapeLayer.fillColor = UIColor.clear.cgColor
      shapeLayer.lineCap = .butt
      
      return shapeLayer
    }
    
}
