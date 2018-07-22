//
//  CoreGraphics+SousChefAdditions.swift
//  SousChef
//
//  Created by Jonathan Long on 2/15/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
	
	// Rects should be normalize rects.
	init(rects: [CGRect]) {
		var minimumX = CGFloat.greatestFiniteMagnitude
		var minimumY = CGFloat.greatestFiniteMagnitude
		var maximumX = CGFloat.leastNormalMagnitude
		var maximumY = CGFloat.leastNormalMagnitude
		
		for rect in rects {
			minimumX = min(rect.minX, minimumX)
			minimumY = min(rect.minY, minimumY)
			maximumY = max(rect.maxY, maximumY)
			maximumX = max(rect.maxX, maximumX)
		}
		
		self.init(x: minimumX, y: minimumY, width: maximumX - minimumX, height: maximumY - minimumY)
	}
    
    static func sortedTopToBottomLeftToRight(rect1: CGRect, rect2: CGRect) -> Bool {
        return rect1.minX <= rect2.minX && rect1.minY <= rect2.minY;
    }
}
