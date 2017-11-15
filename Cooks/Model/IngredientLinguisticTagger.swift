//
//  IngredientLinguisticTagger.swift
//  Cooks
//
//  Created by Jonathan Long on 10/6/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

struct TaggedIngredient {
	
}

class IngredientLinguisticTagger: NSLinguisticTagger {
	
	static let exceptions = ["thyme", "cinnamon", "salt"]
	
	func enumerateTags(using block: (Ingredient) -> Void) {
		guard let inputString = self.string else { return }
		var measurementRanges: Array<NSRange> = Array<NSRange>()
		var measurementTypes : [MeasurementType] = []
		
		self.enumerateTags(in: NSMakeRange(0, inputString.count), unit: .word, scheme: NSLinguisticTagScheme.lemma, options: .omitWhitespace) { (tag, range, stop) in
			guard let measurementTag = tag else { return }
			if !Ingredient.usMeasurementLemma.contains(measurementTag.rawValue) && !Ingredient.metricMeasurementLemma.contains(measurementTag.rawValue) { return }
			let type = MeasurementType(rawValue: measurementTag.rawValue)!
			measurementTypes.append(type)
			measurementRanges.append(range)
		}
		
		var measurementType: MeasurementType = .other
		var currentMeasurementTypeIndex = 0
		
		var nounsAndAdjectives: [String] = []
		var specifiedAmount: [String] = []
		var lastTag = ""
		var ingredientAmount = 0.0
		var isParenthetical = false
		
		self.enumerateTags(in: NSMakeRange(0, inputString.count), unit: .word, scheme: NSLinguisticTagScheme.lexicalClass, options: .omitWhitespace) { (optionalTag, range, stop) in
			guard let tag = optionalTag else { return }
			let start = inputString.index(inputString.startIndex, offsetBy: range.location)
			let end = inputString.index(inputString.startIndex, offsetBy: (range.location + range.length))
			let tokenInQuestion = String(inputString[start..<end])
			
			if measurementRanges.contains(range) {
				if !isParenthetical {
					for amount in specifiedAmount {
						ingredientAmount += amount.fraction
					}
					measurementType = currentMeasurementTypeIndex < measurementTypes.count ? measurementTypes[currentMeasurementTypeIndex] : .other
				}
				currentMeasurementTypeIndex += 1
				return
			}
			
			let lowerCasedToken = tokenInQuestion.lowercased()
			let containsWhiteListedToken = Ingredient.usMeasurementLemma.contains(lowerCasedToken) || Ingredient.metricMeasurementLemma.contains(lowerCasedToken)
			if containsWhiteListedToken { return }
			
			switch tag {
				
			case NSLinguisticTag.number:
				if !isParenthetical {
					if lastTag == NSLinguisticTag.punctuation.rawValue{
						specifiedAmount[specifiedAmount.count - 1].append(tokenInQuestion)
					} else if lastTag == NSLinguisticTag.number.rawValue || lastTag.isEmpty || lastTag == NSLinguisticTag.conjunction.rawValue {
						specifiedAmount.append(tokenInQuestion)
					}
				}
			
			case NSLinguisticTag.openParenthesis:
				isParenthetical = true
			
			case NSLinguisticTag.closeParenthesis:
				isParenthetical = false
				
			case NSLinguisticTag.punctuation:
				if lastTag == NSLinguisticTag.number.rawValue {
					specifiedAmount[specifiedAmount.count - 1].append(tokenInQuestion)
				}
				
			case NSLinguisticTag.noun:
				if !isParenthetical {
					nounsAndAdjectives.append(tokenInQuestion)
				}
				
			case NSLinguisticTag.adjective:
				if !isParenthetical {
					nounsAndAdjectives.append(tokenInQuestion)
				}
				
			default:
				break
			}
			
			if IngredientLinguisticTagger.exceptions.contains(tokenInQuestion) && !nounsAndAdjectives.contains(tokenInQuestion) && !isParenthetical {
				nounsAndAdjectives.append(tokenInQuestion)
			}
			
			lastTag = tag.rawValue
		}
		
		ingredientAmount = ingredientAmount == 0 && specifiedAmount.count > 0 ? specifiedAmount[0].fraction: ingredientAmount
		let item = nounsAndAdjectives.joined(separator: " ")
		let ingredient = Ingredient(measurementType: measurementType, amount: ingredientAmount, item: item, original: inputString)
		print(ingredient)
		block(ingredient)
	}
}

extension String {
	var fraction: Double {
		get {
			if self.contains("/") {
				let numbers = self.split(separator: "/")
				if numbers.count < 2 { return -1 }
				guard var first = numbers.first else { return -1 }
				guard let last = numbers.last else { return -1 }
				var num = Double(0)
				if first.contains(" ") {
					let newFirst = first.split(separator: " ")
					num = Double(String(newFirst.first!))!
					first = newFirst.last!
				}
				
				guard let numerator = Double(String(first)) else { return -1 }
				guard let denominator = Double(String(last)) else { return -1 }
				
				return (numerator + num) / denominator
			} else {
				return Double(self)!
			}
		}
	}
}
