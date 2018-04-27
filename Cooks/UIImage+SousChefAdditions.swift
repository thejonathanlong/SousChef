//
//  UIImage+SousChefAdditions.swift
//  SousChef
//
//  Created by Jonathan Long on 1/20/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import Foundation
import UIKit
import Vision

extension UIImage {
	
	static func grayScale(image: UIImage) -> UIImage {
		guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else {
			print("Failed to create filter 'Noir'. Image is unchanged.")
			return image
			
		}
		currentFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
		let context = CIContext(options: nil)
		
		guard let output = currentFilter.outputImage else {
			print("Failed to get output image from filter. Image is unchanged.")
			return image
		}
		
		guard let cgimg = context.createCGImage(output, from: output.extent) else {
			print("Failed to create CGImage from CIContext. Image is unchanged.")
			return image
			
		}
		
		return UIImage(cgImage: cgimg)
	}

	func aggregatedWordRects() -> [CGRect] {
		var aggregatedRects = [CGRect]()
		guard let underlyingCGImage = cgImage else { return aggregatedRects }
		
		let textRectanglesWaiter = DispatchSemaphore(value: 0)
		let imageRequestHandler = VNImageRequestHandler(cgImage: underlyingCGImage, options: [:])
		let textRectangleRequest = VNDetectTextRectanglesRequest { (request, error) in
			if let err = error { print("There was an error: \(err)"); return } // There was an error abort.
			guard let observations = request.results else { print("Didn't get any results, did the request fail?"); return }
			
			var textRectangleObservations = [TextRectangleObservation]()
			// Get all the rects that have identified Text.
			let textObservations = observations.map({$0 as! VNTextObservation})
			for textObservation in textObservations {
				let textRectangleObservation = textObservation.textRectangleObservation(with: self.size)
				textRectangleObservations.append(textRectangleObservation)
			}
			
			let groupedObservations = TextRectangleObservation.group(observations: textRectangleObservations)
			
			for rectObservation in groupedObservations {
				aggregatedRects.append(rectObservation.rect)
			}
			
			textRectanglesWaiter.signal()
		}
		textRectangleRequest.reportCharacterBoxes = true
		
		do {
			try imageRequestHandler.perform([textRectangleRequest])
		}
		catch {
			print("ImageRequstHandler.perform() threw....")
			textRectanglesWaiter.signal()
		}
		
		textRectanglesWaiter.wait()
		return aggregatedRects
		
	}
}

struct TextRectangleObservation: CustomDebugStringConvertible, CustomStringConvertible {
	let normalizedRect: CGRect
	let rect: CGRect

	var debugDescription: String {
		return "\(normalizedRect) -> \(rect)"
	}
	
	var description: String {
		return debugDescription
	}
	
	static func +(left: TextRectangleObservation, right: TextRectangleObservation) -> TextRectangleObservation {
		return TextRectangleObservation(normalizedRect: left.normalizedRect + right.normalizedRect, rect: left.rect + right.rect)
	}
	
	
	// Compare all observations to each other. If two observations normalized rects should be grouped remove those observations and add a new observation that is the combination of the two.
	static func group(observations: [TextRectangleObservation]) -> [TextRectangleObservation] {
		var mutableObservations = observations
		var successfullyGroupedRects = true
		while successfullyGroupedRects {
			successfullyGroupedRects = false
			for (index1, observation1) in mutableObservations.enumerated() {
				for (index2, observation2) in mutableObservations.enumerated() {
					if index1 != index2 && CGRect.shouldGroup(rect1: observation1.normalizedRect, rect2: observation2.normalizedRect) {
						successfullyGroupedRects = true
						let mindex = min(index1, index2)
						let maxIndex = max(index1, index2)
						let newObservation = observation1 + observation2
						mutableObservations[mindex] = newObservation
						mutableObservations[maxIndex] = TextRectangleObservation(normalizedRect: .null, rect: .null)
					}
				}
			}
		}
		
		return mutableObservations
	}
}

extension CGRect {
	static func +(left: CGRect, right: CGRect) -> CGRect {
		let normalizedMinY = min(left.minY, right.minY)
		let normalizedMinX = min(left.minX, right.minX)
		let normalizedWidth = max(left.maxX, right.maxX) - normalizedMinX
		let normalizedHeight = max(left.maxY, right.maxY) - normalizedMinY
		
		return CGRect(x: normalizedMinX , y: normalizedMinY, width: normalizedWidth, height: normalizedHeight)
	}
	
	// rect1 and rect 2 should be normalized
	static func shouldGroup(rect1: CGRect, rect2: CGRect) -> Bool {
		let xOrigin1 = rect1.minX
		let xOrigin2 = rect2.minX
		
		let yOrigin1 = rect1.minY
		let yOrigin2 = rect2.minY
		
		return rect1.intersects(rect2) || fabs(xOrigin1 - xOrigin2) <= 0.01 && fabs(yOrigin1 - yOrigin2) <= 0.05
	}
}

extension VNTextObservation {
	func textRectangleObservation(with size: CGSize) -> TextRectangleObservation {
		guard let characterBoxes = self.characterBoxes else { return TextRectangleObservation(normalizedRect: .null, rect: .null) }
		
		var maxX: CGFloat = CGFloat.greatestFiniteMagnitude
		var minX: CGFloat = 0.0
		var maxY: CGFloat = CGFloat.greatestFiniteMagnitude
		var minY: CGFloat = 0.0
		
		for char in characterBoxes {
			if char.bottomLeft.x < maxX {
				maxX = char.bottomLeft.x
			}
			if char.bottomRight.x > minX {
				minX = char.bottomRight.x
			}
			if char.bottomRight.y < maxY {
				maxY = char.bottomRight.y
			}
			if char.topRight.y > minY {
				minY = char.topRight.y
			}
		}
		
		let xCord = maxX * size.width
		let yCord = (1 - minY) * size.height
		let width = (minX - maxX) * size.width
		let height = (minY - maxY) * size.height
		
		let normalizedRect = CGRect(x: xCord/size.width, y: yCord/size.height, width: width/size.width, height: height/size.height)
		let rect = CGRect(x: xCord, y: yCord, width: width, height: height)
		print("\(normalizedRect) -> \(rect)")
		
		return TextRectangleObservation(normalizedRect: normalizedRect, rect: rect)
	}
}




















