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
        print("-----")
    }
    
    override func tearDown() {
        super.tearDown()
        print("------")
    }
    
}

class IngredientLinguisticTaggerTests: CooksTestCase {
    
    var ingredientLinguisticTagger = IngredientLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: 0)
    
    // MARK: - Measurements
    func testLinguisticTaggerMeasurementTypeCup() {
        ingredientLinguisticTagger.string = "1 cup of milk"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .cup)
            XCTAssertTrue(ingredient.item.contains("milk"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypeCan() {
        ingredientLinguisticTagger.string = "1 can of beans"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .can)
            XCTAssertTrue(ingredient.item.contains("beans"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }

    func testLinguisticTaggerMeasurementTypeQuart() {
        ingredientLinguisticTagger.string = "1 quart of tomatoes"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .quart)
            XCTAssertTrue(ingredient.item.contains("tomatoes"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypeGallon() {
        ingredientLinguisticTagger.string = "1 gallon of milk"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .gallon)
            XCTAssertTrue(ingredient.item.contains("milk"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
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
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 2)
        }
    }
    
    func testLinguisticTaggerMeasurementTypeTablespoon() {
        ingredientLinguisticTagger.string = "1 tablespoon thyme"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .tablespoon)
            XCTAssertTrue(ingredient.item.contains("thyme"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
        }
    }
    
    func testLinguisticTaggerMeasurementTypeOunce() {
        ingredientLinguisticTagger.string = "1 ounce of tomatoes"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .ounce)
            XCTAssertTrue(ingredient.item.contains("tomatoes"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
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
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralCup() {
        ingredientLinguisticTagger.string = "2 cups of milk"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .cup)
            XCTAssertTrue(ingredient.item.contains("milk"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralQuart() {
        ingredientLinguisticTagger.string = "2 quarts of tomatoes"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .quart)
            XCTAssertTrue(ingredient.item.contains("tomatoes"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
            XCTAssertFalse(ingredient.item.contains("of"))
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralGallon() {
        ingredientLinguisticTagger.string = "2 gallons of milk"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .gallon)
            XCTAssertTrue(ingredient.item.contains("milk"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
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
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 2)
        }
    }
    
    // Expected failure. Thyme gets categorized fairly randomly.
    func testLinguisticTaggerMeasurementTypePluralTablespoon() {
        ingredientLinguisticTagger.string = "2 tablespoons thyme"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .tablespoon)
            XCTAssertTrue(ingredient.item.contains("thyme"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
        }
    }
    
    func testLinguisticTaggerMeasurementTypePluralOunce() {
        ingredientLinguisticTagger.string = "2 ounces of tomatoes"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 2)
            XCTAssertTrue(ingredient.measurement.type == .ounce)
            XCTAssertTrue(ingredient.item.contains("tomatoes"))
            XCTAssertFalse(ingredient.item.contains("of"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
        }
    }
    
    // MARK: Fractional Measurements

    // Expected failure until the radar is fixed.
    func testLinguisticTaggerMeasurementTypeCupWithNoOf() {
        ingredientLinguisticTagger.string = "1/2 cup warm water"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 0.5)
            XCTAssertTrue(ingredient.measurement.type == .cup)
            XCTAssertTrue(ingredient.item.contains("warm"))
            XCTAssertTrue(ingredient.item.contains("water"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 2)
        }
    }

    func testLinguisticTaggerMeasurementTypeFractionalCup() {
        ingredientLinguisticTagger.string = "1/3 cup of cane sugar"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1/3)
            XCTAssertTrue(ingredient.measurement.type == .cup)
            XCTAssertTrue(ingredient.item.contains("sugar"))
            XCTAssertTrue(ingredient.item.contains("cane"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 2)
        }
    }
    
    func testLinguisticTaggerMeasurementTypeTeaspoonNoOf() {
        ingredientLinguisticTagger.string = "1 teaspoon sugar"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .teaspoon)
            XCTAssertTrue(ingredient.item.contains("sugar"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1)
        }
    }
    
    func testLinguisticTaggerMultipleNumbers() {
        ingredientLinguisticTagger.string = "1 teaspoon (5 g) sugar"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .teaspoon)
            XCTAssertTrue(ingredient.item.contains("sugar"))
            XCTAssertTrue(ingredient.item.split(separator: " ").count == 1) // Fails because "g" gets classified as a noun because it follows 5...
        }
    }
    
    func testLinguisticTaggerHyphenatedIngredient() {
        ingredientLinguisticTagger.string = "1 packet quick-rise instant dry yeast"
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1)
            XCTAssertTrue(ingredient.measurement.type == .none)
        }
    }
    
    func testLinguisticTaggerMultiNumberFraction() {
        ingredientLinguisticTagger.string = "1 1/2 tablespoons cinnamon" // The number recognized is 11/2 :/
        ingredientLinguisticTagger.enumerateTags { (ingredient) in
            XCTAssertTrue(ingredient.measurement.amount == 1.5)
            XCTAssertTrue(ingredient.measurement.type == .tablespoon)
            XCTAssertTrue(ingredient.item.contains("cinnamon"))
        }
    }

    //MARK: Real World Tests
    
    /*
     Oh She Glows Vegan Cinnamon Rolls: http://ohsheglows.com/2017/05/09/vegan-cinnamon-rolls-with-make-ahead-option/
     For the yeast:
     
     1/2 cup (125 mL) warm water
     1 teaspoon (5 g) sugar
     1 packet (8 g) quick-rise instant dry yeast
     For the dough:
     
     2 1/2 cups + 3 tablespoons (430 g) all-purpose white flour, plus more for kneading
     1/3 cup (67 g) vegan butter
     1/2 cup (125 mL) unsweetened almond milk
     1/3 cup (73 g) cane sugar
     1 teaspoon (6 g) fine sea salt
     For the cinnamon sugar filling:
     
     1/2 cup (110 g) cane sugar
     1 1/2 tablespoons (10 g) cinnamon
     1/4 cup (50 g) vegan butter, melted
     For the pan sauce and frosting:
     
     1/4 cup (50 g) vegan butter, melted
     2 1/2 tablespoons (25 g) unpacked brown sugar or cane sugar
 */
}
