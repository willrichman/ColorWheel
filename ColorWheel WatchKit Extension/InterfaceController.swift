//
//  InterfaceController.swift
//  ColorWheel WatchKit Extension
//
//  Created by William Richman on 10/22/15.
//  Copyright © 2015 Will Richman. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

	@IBOutlet weak var circleButton: WKInterfaceButton!
	
	var currentColor: UIColor = UIColor.blueColor()
	
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
		drawCircle()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

	/**
	Draw a circle using a UIGraphics Image Context with a fill matching the currentColor variable, save it to a UIImage, and set it to be the background image of circleButton.
	*/
	func drawCircle() {
		// Following this Stack Overflow answer by shu223 (Shuichi Tsutsumi): http://stackoverflow.com/a/31405141/4146745
		
		// Create a graphics context
		let screenWidth = WKInterfaceDevice.currentDevice().screenBounds.width
		let size = CGSizeMake(screenWidth, screenWidth)
		UIGraphicsBeginImageContext(size)
		let context = UIGraphicsGetCurrentContext()
		UIGraphicsPushContext(context!)
		
		// Setup for the path appearance
		currentColor.setFill()
		
		// Draw an oval
		let rect = CGRectMake(2, 2, screenWidth - 2, screenWidth - 2)
		let path = UIBezierPath(ovalInRect: rect)
		path.lineWidth = 4.0
		path.fill()
		path.stroke()
		
		// Convert to UIImage
		let cgimage = CGBitmapContextCreateImage(context)
		let uiimage = UIImage(CGImage: cgimage!)
		
		// End the graphics context
		UIGraphicsPopContext()
		UIGraphicsEndImageContext()
		
		circleButton.setBackgroundImage(uiimage)
	}
	
}
