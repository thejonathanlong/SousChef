//
//  IngredientLinguisticTagger.swift
//  Cooks
//
//  Created by Jonathan Long on 10/6/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit

struct TaggedIngredient {
    var measurementType: MeasurementType
    var amount: Double
    var item: String
    var original: String
}

class IngredientLinguisticTagger: NSLinguisticTagger {
    
    var taggedIngredient = TaggedIngredient(measurementType: .none, amount: 0, item: "", original: "")
    
    func enumerateTags(using block: (Ingredient) -> Void) {
        guard let inputString = self.string else { return }
        var measurementRanges : Array<NSRange> = Array<NSRange>()
        self.enumerateTags(in: NSMakeRange(0, inputString.count), unit: .word, scheme: NSLinguisticTagScheme.lemma, options: .omitWhitespace) { (tag, range, stop) in
            guard let measurementTag = tag else { return }
            if !Ingredient.usMeasurementLemma.contains(measurementTag.rawValue) && !Ingredient.metricMeasurementLemma.contains(measurementTag.rawValue) { return }
            taggedIngredient.measurementType = MeasurementType(rawValue: measurementTag.rawValue)!
            measurementRanges.append(range)
            
        }
        
        
        var nounsAndAdjectives : [String] = []
        var specifiedAmount = ""
        var lastTag = ""
        
        self.enumerateTags(in: NSMakeRange(0, inputString.count), unit: .word, scheme: NSLinguisticTagScheme.lexicalClass, options: .omitWhitespace) { (optionalTag, range, stop) in
            guard let tag = optionalTag else { return }
            if measurementRanges.contains(range) { return }
            
            let start = inputString.index(inputString.startIndex, offsetBy: range.location)
            let end = inputString.index(inputString.startIndex, offsetBy: (range.location + range.length))
            let tokenInQuestion = String(inputString[start..<end])
            let lowerCasedToken = tokenInQuestion.lowercased()
            let containsWhiteListedToken = Ingredient.usMeasurementLemma.contains(lowerCasedToken) || Ingredient.metricMeasurementLemma.contains(lowerCasedToken)
            if containsWhiteListedToken { return }
            
            switch tag {
            case NSLinguisticTag.number:
                if lastTag == NSLinguisticTag.punctuation.rawValue || lastTag == NSLinguisticTag.number.rawValue || lastTag.isEmpty {
                    specifiedAmount.append(tokenInQuestion)
                }
                
            case NSLinguisticTag.punctuation:
                if lastTag == NSLinguisticTag.number.rawValue {
                    specifiedAmount.append(tokenInQuestion)
                }
                
            case NSLinguisticTag.noun:
                nounsAndAdjectives.append(tokenInQuestion)
                
            case NSLinguisticTag.adjective:
                if lastTag == NSLinguisticTag.adjective.rawValue || lastTag.isEmpty || lastTag == NSLinguisticTag.number.rawValue {
                    nounsAndAdjectives.append(tokenInQuestion)
                }
                
            default:
                break
            }
            
            lastTag = tag.rawValue
        }
        
        taggedIngredient.amount = specifiedAmount.count != 0 ? specifiedAmount.fraction : 0.0
        taggedIngredient.item = nounsAndAdjectives.joined(separator: " ")
        taggedIngredient.original = inputString
        let ingredient = Ingredient(measurementType: taggedIngredient.measurementType, amount: taggedIngredient.amount, item: taggedIngredient.item, original: taggedIngredient.original)
        print(ingredient)
        block(ingredient)
    }
}

extension String {
    var fraction : Double {
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
