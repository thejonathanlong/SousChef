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
	
//	func textRects() -> [CGRect] {
//		var rects: [CGRect] = []
//		let imageRequestHandler = VNImageRequestHandler(cgImage: underlyingCGImage, options: [:])
//		let request = VNDetectTextRectanglesRequest { (request, error) in
//			if let err = error {
//				print("There was an error:\(err)")
//				return
//			}
//
//			guard let observations = request.results else {
//				print("No results")
//				return
//			}
//
//			// Get all the rects that have identified Text.
//			let textObservations = observations.map({$0 as? VNTextObservation})
//			for textObservation in textObservations {
//				if let to = textObservation {
//					let wordRect = self.wordRectangle(from: to)
//					rects.append(wordRect)
//				}
//			}
//		}
//	}
	
	
	func aggregatedWordRects() -> [CGRect] {
		var aggregatedRects = [CGRect]()
		guard let underlyingCGImage = cgImage else { return aggregatedRects }
		
		let textRectanglesWaiter = DispatchSemaphore(value: 0)
		let imageRequestHandler = VNImageRequestHandler(cgImage: underlyingCGImage, options: [:])
		let request = VNDetectTextRectanglesRequest { (request, error) in
			if let err = error { print("There was an error: \(err)"); return } // There was an error abort.
			guard let observations = request.results else { print("Didn't get any results, did the request fail?"); return }
			
			var normalizedRects = [CGRect]()
			// Get all the rects that have identified Text.
			let textObservations = observations.map({$0 as! VNTextObservation})
			for textObservation in textObservations {
//				let wordRect = self.normalizedWordRectangles(from: textObservation)
				let wordObservation = self.wordRectangle(from: textObservation)
//				aggregatedRects.append(otherWordRect)
				normalizedRects.append(wordObservation.normalized)
			}
			
//			for rect1 in normalizedRects {
//				for rect2 in normalizedRects {
//					if (rect1 != rect2) {
//						let groupedRect = self.shouldGroup(rect1, rect2)
//						if groupedRect != .null {
//							if let rect1Index = normalizedRects.index(of: rect1), let rect2Index = normalizedRects.index(of: rect2) {
//								normalizedRects.insert(groupedRect, at: min(rect1Index, rect2Index))
//								normalizedRects.remove(at: rect1Index)
//								normalizedRects.remove(at: rect2Index)
//							}
//						}
//					}
//				}
//			}
			
//			for rect in normalizedRects {
//				aggregatedRects.append(self.wordRect(from: rect))
//			}
			
			textRectanglesWaiter.signal()
		}
		request.reportCharacterBoxes = true
		
		do {
			try imageRequestHandler.perform([request])
		}
		catch {
			print("ImageRequstHandler.perform() threw....")
			textRectanglesWaiter.signal()
		}
		
		textRectanglesWaiter.wait()
		return aggregatedRects
		
	}
	
	func cropImageToInterestingText() -> UIImage {
		if let underlyingCGImage = cgImage {
			var newImage = UIImage()
			let semaphore = DispatchSemaphore(value: 0)
			var interestingRects: [CGRect] = []
			let imageRequestHandler = VNImageRequestHandler(cgImage: underlyingCGImage, options: [:])
			let request = VNDetectTextRectanglesRequest { (request, error) in
				if let err = error {
					print("There was an error:\(err)")
					return
				}
				
				guard let observations = request.results else {
					print("No results")
					return
				}
				
				// Get all the rects that have identified Text.
				let textObservations = observations.map({$0 as? VNTextObservation})
				for textObservation in textObservations {
					if let to = textObservation {
						let wordRect = self.wordRectangle(from: to)
						interestingRects.append(wordRect.r)
					}
				}
				
				let combinedRect = CGRect(rects: interestingRects)
				if let croppedCGImage = underlyingCGImage.cropping(to: combinedRect) {
					newImage = UIImage(cgImage: croppedCGImage)
				}
				
				semaphore.signal()
			}
			
			do {
				request.reportCharacterBoxes = true
				try imageRequestHandler.perform([request])
			}
			catch {
				print("ImageRequstHandler.perform() threw....")
				semaphore.signal()
			}
			semaphore.wait()
			
			return newImage
		}
		
		return UIImage()
	}
	
	// rect1 and rect 2 should be normalized
	func shouldGroup(_ rect1: CGRect, _ rect2: CGRect) -> CGRect {
		let xOrigin1 = rect1.minX
		let xOrigin2 = rect2.minX
		
		let yOrigin1 = rect1.minY
		let yOrigin2 = rect2.minY
		
		if (fabs(xOrigin1 - xOrigin2) <= 0.01 && fabs(yOrigin1 - yOrigin2) <= 0.05) {
			let y = min(rect1.minY, rect2.minY)
			return CGRect(x: min(rect1.minX, rect2.minX), y: y, width: max(rect1.width, rect2.width), height: min(rect1.maxY, rect2.maxY) - y)
		}
		else {
			return .null
		}
	}
	
	func normalizedWordRectangles(from textObservation: VNTextObservation) -> CGRect {
		guard let characterBoxes = textObservation.characterBoxes else { return .zero }
		
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

		return CGRect(x: minX, y: minY, width: minX - maxX, height: minY - maxY)
	}
	
	func wordRect(from rect: CGRect) -> CGRect {
		let xCord = rect.maxX * size.width
		let yCord = (1 - rect.minY) * size.height
		let width = rect.width * size.width
		let height = rect.height * size.height
		
		return CGRect(x: xCord, y: yCord, width: width, height: height)
	}
	
	func wordRectangle(from textObservation: VNTextObservation) -> (normalized: CGRect, r: CGRect){
		guard let characterBoxes = textObservation.characterBoxes else { return (.zero, .zero) }
		
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
		let r = CGRect(x: xCord, y: yCord, width: width, height: height)
		print("\(normalizedRect) -> \(r)")
		
		return (normalizedRect, r)
	}
}
