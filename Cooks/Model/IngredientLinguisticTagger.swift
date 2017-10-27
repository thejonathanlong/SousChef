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
    var amount: Float
    var item: String
    var original: String
}

class IngredientLinguisticTagger: NSLinguisticTagger {
    
    var taggedIngredient = TaggedIngredient(measurementType: .none, amount: 0, item: "", original: "")
    
    func enumerateTags(using block: (Ingredient) -> Void) {
        guard let original = self.string else { return }
        var string = original
        self.enumerateTags(in: NSMakeRange(0, original.count), unit: .word, scheme: NSLinguisticTagScheme.lemma, options: .omitWhitespace) { (tag, range, stop) in
            guard let measurementTag = tag else { return }
            if !Ingredient.usMeasurementLemma.contains(measurementTag.rawValue) && !Ingredient.metricMeasurementLemma.contains(measurementTag.rawValue) { return }
            taggedIngredient.measurementType = MeasurementType(rawValue: measurementTag.rawValue)!
            
            // Remove the token so it does not apear in the item result
            let start = string.index(string.startIndex, offsetBy: range.location)
            let end = string.index(string.startIndex, offsetBy: (range.location + range.length))
        }
        
        
        var nounsAndAdjectives : [String] = []
        var specifiedAmount = ""
        var lastTag = ""
        
        self.enumerateTags(in: NSMakeRange(0, string.count), unit: .word, scheme: NSLinguisticTagScheme.lexicalClass, options: .omitWhitespace) { (optionalTag, range, stop) in
            guard let tag = optionalTag else { return }
            
            let start = string.index(string.startIndex, offsetBy: range.location)
            let end = string.index(string.startIndex, offsetBy: (range.location + range.length))
            let tokenInQuestion = String(string[start..<end])
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
                if lastTag == NSLinguisticTag.adjective.rawValue || lastTag.isEmpty {
                    nounsAndAdjectives.append(tokenInQuestion)
                }
                
            default:
                break
            }
            
            lastTag = tag.rawValue
        }
        
        taggedIngredient.amount = Float(specifiedAmount)!
        taggedIngredient.item = nounsAndAdjectives.joined(separator: " ")
        taggedIngredient.original = original
        let ingredient = Ingredient(measurementType: taggedIngredient.measurementType, amount: taggedIngredient.amount, item: taggedIngredient.item, original: taggedIngredient.original)
        print(ingredient)
        block(ingredient)
    }
    
}
