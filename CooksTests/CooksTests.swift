//
//  CooksTests.swift
//  CooksTests
//
//  Created by Jonathan Long on 10/12/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import XCTest
import Foundation

class CooksTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        print("\n-----")
    }
    
    override func tearDown() {
        super.tearDown()
        print("------\n")
    }
    
}

class IngredientLinguisticTaggerTests: CooksTestCase {
    
    let ingredientLinguisticTagger = IngredientLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: 0)
    
    // MARK: - Measurements
    func testLinguisticTaggerMeasurementTypeCup() {
        ingredientLinguisticTagger.string = "1 cup of milk"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .cup)
            XCTAssertTrue(ingredient.item.contains("milk"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypeCan() {
        ingredientLinguisticTagger.string = "1 can of beans"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .can)
            XCTAssertTrue(ingredient.item.contains("beans"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }

    func testLinguisticTaggerMeasurementTypeQuart() {
        ingredientLinguisticTagger.string = "1 quart of tomatoes"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .quart)
            XCTAssertTrue(ingredient.item.contains("tomatoes"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypeGallon() {
        ingredientLinguisticTagger.string = "1 gallon of milk"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .gallon)
            XCTAssertTrue(ingredient.item.contains("milk"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypeTeaspoon() {
        ingredientLinguisticTagger.string = "1 teaspoon chili powder"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .teaspoon)
            XCTAssertTrue(ingredient.item.contains("chili"))
            XCTAssertTrue(ingredient.item.contains("powder"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypeTablespoon() {
        ingredientLinguisticTagger.string = "1 tablespoon thyme"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .tablespoon)
            XCTAssertTrue(ingredient.item.contains("thyme"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypeOunce() {
        ingredientLinguisticTagger.string = "1 ounce of tomatoes"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .ounce)
            XCTAssertTrue(ingredient.item.contains("tomatoes"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    // MARK: - Plural Measurements
    func testLinguisticTaggerMeasurementTypePluralCan() {
        ingredientLinguisticTagger.string = "2.7 cans of beans"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2.7)
            XCTAssertTrue(ingredient.measurement.type == .can)
            XCTAssertTrue(ingredient.item.contains("beans"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralCup() {
        ingredientLinguisticTagger.string = "2 cups of milk"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .cup)
            XCTAssertTrue(ingredient.item.contains("milk"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralQuart() {
        ingredientLinguisticTagger.string = "2 quarts of tomatoes"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .quart)
            XCTAssertTrue(ingredient.item.contains("tomatoes"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralGallon() {
        ingredientLinguisticTagger.string = "2 gallons of milk"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .gallon)
            XCTAssertTrue(ingredient.item.contains("milk"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralTeaspoon() {
        ingredientLinguisticTagger.string = "2 teaspoons chili powder"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            print(String(describing: ingredient))
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .teaspoon)
            XCTAssertTrue(ingredient.item.contains("chili"))
            XCTAssertTrue(ingredient.item.contains("powder"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralTablespoon() {
        ingredientLinguisticTagger.string = "2 tablespoons thyme"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .tablespoon)
            XCTAssertTrue(ingredient.item.contains("thyme"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralOunce() {
        ingredientLinguisticTagger.string = "2 ounces of tomatoes"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .ounce)
            XCTAssertTrue(ingredient.item.contains("tomatoes"))
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
}
