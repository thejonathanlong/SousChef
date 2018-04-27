//
//  TextRecognizer.swift
//  SousChef
//
//  Created by Jonathan Long on 1/20/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit
import TesseractOCR
import Vision

typealias TextRecognizerCompletionHandler = (String) -> Void

class TextRecognizer: NSObject, G8TesseractDelegate {
	static let shared = TextRecognizer()
	private let tesseract = G8Tesseract(language: "eng")
	private let operationQueue = OperationQueue()
	
	func recognizeText(in image: UIImage, completionHandler: @escaping TextRecognizerCompletionHandler) {
		let interestingImage = image//image.cropImageToInterestingText()
		let image = UIImage.grayScale(image: interestingImage)
		tesseract?.image = image

		let textRecognitionBlockerOperation = BlockOperation {
			self.tesseract?.recognize()
			guard let recognizedText = self.tesseract?.recognizedText else {
				completionHandler("")
				return
			}
			completionHandler(recognizedText)
		}
		
		operationQueue.addOperation(textRecognitionBlockerOperation)
		
		let timeoutTime = DispatchTime.now() + .seconds(15)
		DispatchQueue.main.asyncAfter(deadline: timeoutTime) {
			print("Canceling textRecognition block because it has been 15 seconds...")
			textRecognitionBlockerOperation.cancel()
		}
	}
}
