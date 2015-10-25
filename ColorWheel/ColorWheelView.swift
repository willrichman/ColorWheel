//
//  ColorWheelView.swift
//  ColorWheel
//
//  Created by William Richman on 10/24/15.
//  Copyright © 2015 Will Richman. All rights reserved.
//

import UIKit

protocol RotaryWheelDelegate {
	func wheelDidChangeValue(newValue: String)
}

/// A UIControl subclass that is drawn as a segmented wheel that rotates when the user touches it. Based on the Ray Wenderlich tutorial at http://www.raywenderlich.com/9864/how-to-create-a-rotating-wheel-control-with-uikit
class ColorWheelView: UIControl {
	
	var delegate: RotaryWheelDelegate?
	var container: UIView!

	var sections: Int = 4
	
	var deltaAngle: CGFloat?
	var startTransform: CGAffineTransform?
	
	init(frame: CGRect, sections: Int) {
		super.init(frame: frame)
		self.sections = sections
		drawWheel()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func drawWheel() {
		container = UIView(frame: bounds)
		container.userInteractionEnabled = false
		addSubview(container)
		
		let radius = min(bounds.width, bounds.height) / 2
		let angle: CGFloat = CGFloat(2.0 * M_PI) / CGFloat(sections)
		print(angle)
		print(container.center)
		
		for section in  0..<sections {
			
			let sectionLayer = CAShapeLayer(layer: container.layer)
			let startAngle = CGFloat(section) * angle
			let endAngle = CGFloat(section + 1) * angle
			let path = UIBezierPath(arcCenter: container.center, radius: radius - 1, startAngle: startAngle, endAngle: endAngle, clockwise: true)
			path.addLineToPoint(container.center)
			path.closePath()
			let hue = CGFloat(section) / CGFloat(sections)
			let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)

			sectionLayer.path = path.CGPath
			sectionLayer.fillColor = color.CGColor
			
			container.layer.addSublayer(sectionLayer)
		}
		


	}
	
	override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
		// Get touch position
		let touchPoint = touch.locationInView(self)
		let dist = calculateDistanceFromCenter(touchPoint)
		
		if dist < 40 || dist > bounds.width / 2 - 1 {
			return false
		}
		
		// Calculate distance from center
		let deltaY = touchPoint.x - container.center.x
		let deltaX = touchPoint.y - container.center.y
		// Calculate arctangent value
		deltaAngle = atan2(deltaY, deltaX)
		startTransform = container.transform
		return true
	}
	
	override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
		let touchPoint = touch.locationInView(self)
		let deltaY = touchPoint.x - container.center.x
		let deltaX = touchPoint.y - container.center.y
		// Calculate arctangent value
		let newAngle = atan2(deltaY, deltaX)
		let angleDifference = deltaAngle! - newAngle
		container.transform = CGAffineTransformRotate(startTransform!, angleDifference)
		return true
	}

	func calculateDistanceFromCenter(point: CGPoint) -> CGFloat {
		let center = CGPointMake(bounds.width / 2, bounds.height / 2)
		let deltaX = point.x - center.x
		let deltaY = point.y - center.y
		return sqrt(deltaX * deltaX + deltaY * deltaY)
	}
	
}
