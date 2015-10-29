//
//  ColorWheelView.swift
//  ColorWheel
//
//  Created by William Richman on 10/24/15.
//  Copyright © 2015 Will Richman. All rights reserved.
//

import UIKit

protocol RotaryWheelDelegate {
	func wheelDidChangeValue(newValue: UIColor)
}

/// A UIControl subclass that is drawn as a segmented wheel that rotates when the user touches it. Based on the Ray Wenderlich tutorial at http://www.raywenderlich.com/9864/how-to-create-a-rotating-wheel-control-with-uikit
class ColorWheelView: UIControl {
	
	var delegate: RotaryWheelDelegate?
	var container: UIView!

	var numberOfSections: Int = 4
	var sections = [ColorWheelSection]()
	var currentSection: Int?
	
	var deltaAngle: CGFloat?
	var startTransform: CGAffineTransform?
	
	init(frame: CGRect, sections: Int) {
		super.init(frame: frame)
		self.numberOfSections = sections
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
		let angle: CGFloat = CGFloat(2.0 * M_PI) / CGFloat(numberOfSections)
		print(angle)
		print(container.center)
		
		// For each section in the wheel, draw an arc from the edge offset by the number of sections, draw a line to the center, then close the path and fill it with a color evenly spread across hues.
		
		for section in  0..<numberOfSections {
			
			let sectionLayer = CAShapeLayer(layer: container.layer)
			let startAngle = CGFloat(section) * angle
			print(startAngle)
			let endAngle = CGFloat(section + 1) * angle
			print(endAngle)
			let path = UIBezierPath(arcCenter: container.center, radius: radius - 1, startAngle: startAngle, endAngle: endAngle, clockwise: true)
			path.addLineToPoint(container.center)
			path.closePath()
			let hue = CGFloat(section) / CGFloat(numberOfSections)
			
			let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
			
			sectionLayer.path = path.CGPath
			sectionLayer.fillColor = color.CGColor
			
			container.layer.addSublayer(sectionLayer)
			
			let newSection = ColorWheelSection()
			newSection.sector = section
			newSection.color = color
			sections.append(newSection)
		}
		
		if numberOfSections % 2 == 0 {
			buildSectionsEven()
		} else {
			buildSectionsOdd()
		}
		
		transform = CGAffineTransformMakeRotation(-(CGFloat(M_PI) * 90/180 + (angle / 2)))

	}
	
	// MARK: - Handling touches
	
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
	
	override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
		// Get current container rotation in radians
		let radians: CGFloat = atan2(container.transform.b, container.transform.a)
		// Initialize new value
		var newValue: CGFloat = 0.0
		// Iterate through all the sections
		for section in sections {
			if (section.minValue > 0 && section.maxValue < 0) {
				if (section.maxValue > radians || section.minValue < radians) {
					// Find the quadrant (positive or negative)
					if radians > 0 {
						newValue = radians - CGFloat(M_PI)
					} else {
						newValue = radians + CGFloat(M_PI)
					}
					currentSection = section.sector
				}
			} else if (radians > section.minValue && radians < section.maxValue) {
				newValue = radians - section.midValue
				currentSection = section.sector
			}
		}
		
		let currentColor = sections[currentSection!].color
		delegate?.wheelDidChangeValue(currentColor)
		// Set up animation for final rotation
		
		UIView.animateWithDuration(0.2) { () -> Void in
			let newTransform = CGAffineTransformRotate(self.container.transform, -newValue)
			self.container.transform = newTransform
		}
		
	}

	func calculateDistanceFromCenter(point: CGPoint) -> CGFloat {
		let center = CGPointMake(bounds.width / 2, bounds.height / 2)
		let deltaX = point.x - center.x
		let deltaY = point.y - center.y
		return sqrt(deltaX * deltaX + deltaY * deltaY)
	}

	// MARK: - Defining sections
	
	func buildSectionsEven() {
		// Define section length
		let radWidth: CGFloat = CGFloat(M_PI * 2) / CGFloat(numberOfSections)
		// Set initial midpoint
		var mid: CGFloat = 0.0
		// Iterate through all sections
		for index in 0..<numberOfSections {
			let section = sections[index]
			// Set section values
			section.midValue = mid
			section.minValue = mid - (radWidth / 2)
			section.maxValue = mid + (radWidth / 2)
			if (section.maxValue - radWidth < CGFloat(-M_PI)) {
				mid = CGFloat(M_PI)
				section.midValue = mid
				section.minValue = fabs(section.maxValue)
			}
			mid -= radWidth
			sections.append(section)
		}
	}
	
	func buildSectionsOdd() {
		// Define section length
		let radWidth: CGFloat = CGFloat(M_PI * 2) / CGFloat(numberOfSections)
		// Set initial midpoint
		var mid: CGFloat = 0.0
		// Iterate through all sections
		for index in 0..<numberOfSections {
			let section = sections[index]
			// Set section values
			section.midValue = mid
			section.minValue = mid - (radWidth / 2)
			section.maxValue = mid + (radWidth / 2)
			section.sector = index
			mid -= radWidth
			if (section.minValue < CGFloat(-M_PI)) {
				mid = -mid
				mid -= radWidth
			}
			sections.append(section)
		}
	}
	
}
