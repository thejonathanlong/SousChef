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
	private let operationQueue = OperationQueue()
	
	func recognizeText(in image: UIImage, completionHandler: @escaping TextRecognizerCompletionHandler) {
		let textRecognitionBlockerOperation = BlockOperation {
            let tesseract = G8Tesseract(language: "eng")
            let interestingImage = image//image.cropImageToInterestingText()
            let image = UIImage.grayScale(image: interestingImage)
            tesseract?.image = image
			tesseract?.recognize()
			guard let recognizedText = tesseract?.recognizedText else {
				completionHandler("")
				return
			}
			completionHandler(recognizedText)
		}
		
		operationQueue.addOperation(textRecognitionBlockerOperation)
		
		let timeoutTime = DispatchTime.now() + .seconds(15)
		DispatchQueue.main.asyncAfter(deadline: timeoutTime) {
            if !textRecognitionBlockerOperation.isFinished {
                print("Canceling textRecognition block because it has been 15 seconds...")
                textRecognitionBlockerOperation.cancel()
            }
		}
	}
}

extension TextRecognizer {
    // Splits a chunk of texts up by sentences.
    func findSentences(text: String, removingLeadingNumbers: Bool) -> [String] {
        var sentences: [String] = []
        var currentGroup = ""
        let sentenceTagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: 0)
        sentenceTagger.string = text
        sentenceTagger.enumerateTags(in: NSMakeRange(0, text.count), unit: .sentence, scheme: .language, options: .joinNames) { (tagOrNil, range, stop) in
            let start = text.index(text.startIndex, offsetBy: range.location)
            let end = text.index(text.startIndex, offsetBy: (range.location + range.length))
            let tokenInQuestion = String(text[start..<end])
            if (tokenInQuestion != "\n")
            {
                if removingLeadingNumbers {
                    let sentenceWithoutNumber = TextRecognizer.shared.removeLeadingNumberFromSentence(sentence: tokenInQuestion)
                    let didRemoveNumber = sentenceWithoutNumber != tokenInQuestion
                    if didRemoveNumber && currentGroup != "" {
                        sentences.append(currentGroup)
                        currentGroup = sentenceWithoutNumber
                    } else if currentGroup == "" {
                        currentGroup = sentenceWithoutNumber
                    }
                    else {
                        currentGroup.append(sentenceWithoutNumber)
                    }
                } else {
                    sentences.append(tokenInQuestion)
                }
            }
        }
        
        return sentences
    }
    
    func removeLeadingNumberFromSentence(sentence: String) -> String {
        var newSentence = sentence
        let numberRemoverTagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: 0)
        numberRemoverTagger.string = sentence
        var tokenNumber = 0
        var foundNumber = false
        var replacementRangeOffset = 0
        numberRemoverTagger.enumerateTagsAndTokens(in: NSMakeRange(0, sentence.count), unit: .word, scheme: .lexicalClass, using: { (tag, tokenInQuestion, range, stop) in
            tokenNumber += 1
            switch tag {
            case .punctuation:
                if foundNumber { replacementRangeOffset += range.length }
                
            case .sentenceTerminator:
                if foundNumber { replacementRangeOffset += range.length }
                
            case .whitespace:
                if foundNumber {
                    replacementRangeOffset += range.length
                }
                else {
                    stop.pointee = true
                }
                
                
            case .number:
                foundNumber = true
                replacementRangeOffset += range.length
                
            case .otherWord:
                let probablyANumber = TextRecognizer.shared.tokenIsProbablyANumber(token: tokenInQuestion)
                if probablyANumber {
                    print("Found other word \(tokenInQuestion) it's probably a number...")
                }
                foundNumber = probablyANumber
                
            default: break
                
            }
            
            if tokenNumber == 3 { stop.pointee = true }
        })
        
        if replacementRangeOffset != 0 {
            let endIndex = sentence.index(sentence.startIndex, offsetBy:replacementRangeOffset)
            newSentence.replaceSubrange(sentence.startIndex...endIndex, with: "")
        }
        
        return newSentence
    }
    
    func tokenIsProbablyANumber(token: String) -> Bool {
        return token.contains("0") || token.contains("1") || token.contains("2") || token.contains("3") || token.contains("4") || token.contains("5") || token.contains("6") || token.contains("7") || token.contains("8") || token.contains("9")
    }
}
