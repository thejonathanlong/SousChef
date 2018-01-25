//
//  UIImage+SousChefAdditions.swift
//  SousChef
//
//  Created by Jonathan Long on 1/20/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import Foundation
import UIKit

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
}
