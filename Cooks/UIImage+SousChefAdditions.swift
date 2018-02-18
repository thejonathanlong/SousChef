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
						interestingRects.append(wordRect)
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
	
	func wordRectangle(from textObservation: VNTextObservation) -> CGRect{
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
		
		let xCord = maxX * size.width
		let yCord = (1 - minY) * size.height
		let width = (minX - maxX) * size.width
		let height = (minY - maxY) * size.height
		
		return CGRect(x: xCord, y: yCord, width: width, height: height)
	}
}
