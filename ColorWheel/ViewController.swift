//
//  ViewController.swift
//  ColorWheel
//
//  Created by William Richman on 10/22/15.
//  Copyright © 2015 Will Richman. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, RotaryWheelDelegate, WCSessionDelegate {
	
	@IBOutlet weak var colorView: UIView!
	var session: WCSession!
	
	var colorWheelView: ColorWheelView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if (WCSession.isSupported()) {
			session = WCSession.defaultSession()
			session.delegate = self;
			session.activateSession()
		}
		
		let wheelDiameter = view.bounds.width * 0.9
		let wheelFrame = CGRect(x: view.center.x - (wheelDiameter / 2), y: view.center.y - (wheelDiameter / 2), width: wheelDiameter, height: wheelDiameter)
		colorWheelView = ColorWheelView(frame: wheelFrame, sections: 16)
		colorWheelView.delegate = self
		view.addSubview(colorWheelView)
	}

	func wheelDidChangeValue(newValue: UIColor) {
		colorView.backgroundColor = newValue
		
		// Pack the new UIColor value as NSData to pass via WCSession.sendMessage
		let colorToPass = NSKeyedArchiver.archivedDataWithRootObject(newValue)
		let applicationData = ["colorValue": colorToPass]
		
		session.sendMessage(applicationData, replyHandler: { (reply) -> Void in
				print(reply)
			}) { (error) -> Void in
				print(error.localizedDescription)
		}
		
	}

}

