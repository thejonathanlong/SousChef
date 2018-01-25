//
//  TextRecognizer.swift
//  SousChef
//
//  Created by Jonathan Long on 1/20/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit
import TesseractOCR

typealias TextRecognizerCompletionHandler = (String) -> Void

class TextRecognizer: NSObject, G8TesseractDelegate {
	static let shared = TextRecognizer()
	private let tesseract = G8Tesseract(language: "eng")
	private let operationQueue = OperationQueue()
	
	func recognizeText(in image: UIImage, completionHandler: @escaping TextRecognizerCompletionHandler) {
		let image = UIImage.grayScale(image: image)
		tesseract?.image = image

		operationQueue.addOperation {
			self.tesseract?.recognize()
			guard let recognizedText = self.tesseract?.recognizedText else {
				completionHandler("")
				return
			}
			
			completionHandler(recognizedText)
		}
		
	}
	
}
