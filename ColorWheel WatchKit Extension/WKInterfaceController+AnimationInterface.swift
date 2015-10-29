//
//  WKInterfaceController+AnimationInterface.swift
//  ColorWheel
//
//  Created by William Richman on 10/28/15.
//  Copyright © 2015 Will Richman. All rights reserved.
//

import WatchKit
import Foundation


extension WKInterfaceController {

	func animateWithDuration(duration: NSTimeInterval, animations: ()->Void, completion: ()->Void) {
		self.animateWithDuration(duration, animations: animations)
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
		dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
			completion()
		}
	}
	
}
