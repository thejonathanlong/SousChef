//
//  IngredientLinguisticTesterTests.swift
//  CooksTests
//
//  Created by Jonathan Long on 11/14/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import XCTest

class IngredientLinguisticTesterTests: CooksTestCase {
    
	// MARK: IngredientLinguisticTaggerTests
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
				XCTAssertTrue(ingredient.measurement.amount == 1) // Fails because packet is not recognized and so we never compute the amount... it's always 0
				XCTAssertTrue(ingredient.measurement.type == .other)
			}
		}
		
		func testLinguisticTaggerMultiNumberFractionWithAnd() {
			ingredientLinguisticTagger.string = "1 and 1/2 tablespoons cinnamon"
			ingredientLinguisticTagger.enumerateTags { (ingredient) in
				XCTAssertTrue(ingredient.measurement.amount == 1.5)
				XCTAssertTrue(ingredient.measurement.type == .tablespoon)
				XCTAssertTrue(ingredient.item.contains("cinnamon"))
			}
		}
		
		func testLinguisticTaggerMultiNumberFraction() {
			ingredientLinguisticTagger.string = "1 1/2 tablespoons cinnamon"
			ingredientLinguisticTagger.enumerateTags { (ingredient) in
				XCTAssertTrue(ingredient.measurement.amount == 1.5)
				XCTAssertTrue(ingredient.measurement.type == .tablespoon)
				XCTAssertTrue(ingredient.item.contains("cinnamon"))
			}
		}
		
		func testLinguisticTaggerDoubleDigitNumberFraction() {
			ingredientLinguisticTagger.string = "11/2 tablespoons cinnamon"
			ingredientLinguisticTagger.enumerateTags { (ingredient) in
				XCTAssertTrue(ingredient.measurement.amount == 5.5)
				XCTAssertTrue(ingredient.measurement.type == .tablespoon)
				XCTAssertTrue(ingredient.item.contains("cinnamon"))
			}
		}
		
		//MARK: Real World Tests
		
		// Oh She Glows Vegan Cinnamon Rolls
		func testOhSheGlowsVeganCinnamonRolls1() {
			let i = ingredient(info: "1/2 cup (125 mL) of warm water")
			XCTAssertTrue(i.measurement.amount == 0.5)
			XCTAssertTrue(i.measurement.type == .cup)
			XCTAssertTrue(i.item.contains("water"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls2() {
			let i = ingredient(info: "1 teaspoon (5 g) sugar")
			XCTAssertTrue(i.measurement.amount == 1)
			XCTAssertTrue(i.measurement.type == .teaspoon)
			XCTAssertTrue(i.item.contains("sugar"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls3() {
			let i = ingredient(info: "1 packet (8 g) quick-rise instant dry yeast")
			XCTAssertTrue(i.measurement.amount == 1)
			XCTAssertTrue(i.measurement.type == .other)
			XCTAssertTrue(i.item.contains("yeast"))
		}
		
		// Expected failure. We don't handle addition of types right now. We could, but how common is this?
		func testOhSheGlowsVeganCinnamonRolls4() {
			let i = ingredient(info: "2 1/2 cups + 3 tablespoons (430 g) all-purpose white flour, plus more for kneading")
			XCTAssertTrue(i.measurement.amount == 2.5)
			XCTAssertTrue(i.measurement.type == .cup)
			XCTAssertTrue(i.item.contains("flour"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls5() {
			let i = ingredient(info: "1/3 cup (67 g) vegan butter")
			XCTAssertTrue(i.measurement.amount == 1/3)
			XCTAssertTrue(i.measurement.type == .cup)
			XCTAssertTrue(i.item.contains("butter"))
			XCTAssertTrue(i.item.contains("vegan"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls6() {
			let i = ingredient(info: "1/2 cup (125 mL) of unsweetened almond milk")
			XCTAssertTrue(i.measurement.amount == 0.5)
			XCTAssertTrue(i.measurement.type == .cup)
			XCTAssertTrue(i.item.contains("milk"))
			XCTAssertTrue(i.item.contains("almond"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls7() {
			let i = ingredient(info: "1/3 cup (73 g) cane sugar")
			XCTAssertTrue(i.measurement.amount == 1/3)
			XCTAssertTrue(i.measurement.type == .cup)
			XCTAssertTrue(i.item.contains("sugar"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls8() {
			let i = ingredient(info: "1 teaspoon (6 g) fine sea salt")
			XCTAssertTrue(i.measurement.amount == 1)
			XCTAssertTrue(i.measurement.type == .teaspoon)
			XCTAssertTrue(i.item.contains("salt"))
			XCTAssertTrue(i.item.contains("sea"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls9() {
			let i = ingredient(info: "1/2 cup (110 g) cane sugar")
			XCTAssertTrue(i.measurement.amount == 0.5)
			XCTAssertTrue(i.measurement.type == .cup)
			XCTAssertTrue(i.item.contains("sugar"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls10() {
			let i = ingredient(info: "1 1/2 tablespoons (10 g) cinnamon")
			XCTAssertTrue(i.measurement.amount == 1.5)
			XCTAssertTrue(i.measurement.type == .tablespoon)
			XCTAssertTrue(i.item.contains("cinnamon"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls11() {
			let i = ingredient(info: "1/4 cup (50 g) vegan butter, melted")
			XCTAssertTrue(i.measurement.amount == 0.25)
			XCTAssertTrue(i.measurement.type == .cup)
			XCTAssertTrue(i.item.contains("vegan"))
			XCTAssertTrue(i.item.contains("butter"))
		}
		
		func testOhSheGlowsVeganCinnamonRolls12() {
			let i = ingredient(info: "2 1/2 tablespoons (25 g) unpacked brown sugar or cane sugar")
			XCTAssertTrue(i.measurement.amount == 2.5)
			XCTAssertTrue(i.measurement.type == .tablespoon)
			XCTAssertTrue(i.item.contains("brown"))
			XCTAssertTrue(i.item.contains("sugar"))
		}
		
		func testThaiQuinoaIngredients1() {
			let i = ingredient(info: "1 2/3 cups of fresh cilantro (from about 1/2 bunch), long, thick stems removed")
			XCTAssertTrue(i.measurement.amount == (1 + (2/3)))
			XCTAssertTrue(i.measurement.type == .cup)
		}
		
		func testThaiQuinoaIngredients2() {
			let i = ingredient(info: "3/4 cup roasted, unsalted peanuts")
			XCTAssertTrue(i.measurement.amount == 0.75)
			XCTAssertTrue(i.measurement.type == .cup)
		}
		
		// Expected Failure
		func testThaiQuinoaIngredients3() {
			let i = ingredient(info: "1/3 cup of Sriracha hot sauce") // When trying to identify cup everything comes back nil. It's a bug.
			XCTAssertTrue(i.measurement.amount == (1/3))
			XCTAssertTrue(i.measurement.type == .cup)
		}
		
		func testThaiQuinoaIngredients4() {
			let i = ingredient(info: "2 tablespoons finely grated lime zest (from about 3 medium limes)")
			XCTAssertTrue(i.measurement.amount == 2)
			XCTAssertTrue(i.measurement.type == .tablespoon)
		}
		
		func testThaiQuinoaIngredients5() {
			let i = ingredient(info: "1/4 cup freshly squeezed lime juice (from about 3 medium limes)")
			XCTAssertTrue(i.measurement.amount == 0.25)
			XCTAssertTrue(i.measurement.type == .cup)
		}
		
		func testThaiQuinoaIngredients6() {
			let i = ingredient(info: "1/4 cup toasted sesame oil")
			XCTAssertTrue(i.measurement.amount == 0.25)
			XCTAssertTrue(i.measurement.type == .cup)
		}
		
		func testThaiQuinoaIngredients7() {
			let i = ingredient(info: "1 tablespoon packed dark brown sugar")
			XCTAssertTrue(i.measurement.amount == 1)
			XCTAssertTrue(i.measurement.type == .tablespoon)
		}
		
		func testThaiQuinoaIngredients8() {
			let i = ingredient(info: "2 medium garlic cloves")
			XCTAssertTrue(i.measurement.amount == 2)
			XCTAssertTrue(i.measurement.type == .other)
		}
		
		func testThaiQuinoaIngredients9() {
			let i = ingredient(info: "1 1/2 teaspoons kosher salt")
			XCTAssertTrue(i.measurement.amount == 1.5)
			XCTAssertTrue(i.measurement.type == .teaspoon)
		}
		
		func testThaiQuinoaIngredients10() {
			let i = ingredient(info: "2 cups quinoa, any color or variety")
			XCTAssertTrue(i.measurement.amount == 2)
			XCTAssertTrue(i.measurement.type == .cup)
		}
		
		func testThaiQuinoaIngredients11() {
			let i = ingredient(info: "1 (14-ounce) can unsweetened coconut milk")
			XCTAssertTrue(i.measurement.amount == 1)
			XCTAssertTrue(i.measurement.type == .can)
		}
		
		func testThaiQuinoaIngredients12() {
			let i = ingredient(info: "1 1/3 cups vegetable stock or low-sodium vegetable broth")
			XCTAssertTrue(i.measurement.amount == (1 + (1/3)))
			XCTAssertTrue(i.measurement.type == .cup)
		}
		
		func testThaiQuinoaIngredients13() {
			let i = ingredient(info: "1 teaspoon kosher salt, plus more as needed")
			XCTAssertTrue(i.measurement.amount == 1)
			XCTAssertTrue(i.measurement.type == .teaspoon)
		}
		func testThaiQuinoaIngredients14() {
			let i = ingredient(info: "1 (14- to 16-ounce) package firm tofu")
			XCTAssertTrue(i.measurement.amount == 1)
			XCTAssertTrue(i.measurement.type == .other)
		}
		func testThaiQuinoaIngredients15() {
			let i = ingredient(info: "2 medium carrots (about 8 ounces)")
			XCTAssertTrue(i.measurement.amount == 2)
			XCTAssertTrue(i.measurement.type == .other)
		}
		func testThaiQuinoaIngredients16() {
			let i = ingredient(info: "1 medium broccoli head (about 1 pound)")
			XCTAssertTrue(i.measurement.amount == 1)
			XCTAssertTrue(i.measurement.type == .other)
		}
		func testThaiQuinoaIngredients17() {
			let i = ingredient(info: "4 medium scallions")
			XCTAssertTrue(i.measurement.amount == 4)
			XCTAssertTrue(i.measurement.type == .other)
		}
		func testThaiQuinoaIngredients18() {
			let i = ingredient(info: "2 tablespoons vegetable oil")
			XCTAssertTrue(i.measurement.amount == 2)
			XCTAssertTrue(i.measurement.type == .tablespoon)
		}
		
		// MARK: Helpers
		
		func ingredient(info: String) -> Ingredient {
			ingredientLinguisticTagger.string = info
			var i: Ingredient? = nil
			let semaphore = DispatchSemaphore(value: 0)
			ingredientLinguisticTagger.enumerateTags { (ingredient) in
				i = ingredient
				semaphore.signal()
			}
			semaphore.wait()
			return i!
		}
	}
    
}