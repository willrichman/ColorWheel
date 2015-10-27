//
//  ViewController.swift
//  ColorWheel
//
//  Created by William Richman on 10/22/15.
//  Copyright © 2015 Will Richman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RotaryWheelDelegate {
	
	@IBOutlet weak var colorView: UIView!
	
	var colorWheelView: ColorWheelView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let wheelDiameter = view.bounds.width * 0.9
		let wheelFrame = CGRect(x: view.center.x - (wheelDiameter / 2), y: view.center.y - (wheelDiameter / 2), width: wheelDiameter, height: wheelDiameter)
		colorWheelView = ColorWheelView(frame: wheelFrame, sections: 6)
		colorWheelView.delegate = self
		view.addSubview(colorWheelView)
	}

	func wheelDidChangeValue(newValue: UIColor) {
		colorView.backgroundColor = newValue
	}

}

