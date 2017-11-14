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
/*
1 2/3 cups fresh cilantro (from about 1/2 bunch), long, thick stems removed
3/4 cup roasted, unsalted peanuts
1/3 cup Sriracha hot sauce
2 tablespoons finely grated lime zest (from about 3 medium limes)
1/4 cup freshly squeezed lime juice (from about 3 medium limes)
1/4 cup toasted sesame oil
1 tablespoon packed dark brown sugar
2 medium garlic cloves
1 1/2 teaspoons kosher salt
For the quinoa:

2 cups quinoa, any color or variety
1 (14-ounce) can unsweetened coconut milk
1 1/3 cups vegetable stock or low-sodium vegetable broth
1 teaspoon kosher salt, plus more as needed
1 (14- to 16-ounce) package firm tofu
2 medium carrots (about 8 ounces)
1 medium broccoli head (about 1 pound)
4 medium scallions
2 tablespoons vegetable oil
*/

// MARK: MeasurementAdditionTests
class MeasurementAdditionTests: CooksTestCase {
	
	// MARK: - Gallon Addition
	func testGallonPlusGallon() {
		let gallon1 = GallonMeasurement(amount: 1)
		let gallon2 = GallonMeasurement(amount: 1)
		let answer = GallonMeasurement(amount: 2)
		let test = gallon1 + gallon2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testGallonPlusQuart() {
		let gallon1 = GallonMeasurement(amount: 1)
		let gallon2 = QuartMeasurement(amount: 1)
		let answer = GallonMeasurement(amount: 1.25)
		let test = gallon1 + gallon2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testGallonPlusCup() {
		let gallon1 = GallonMeasurement(amount: 1)
		let gallon2 = CupMeasurement(amount: 1)
		let answer = GallonMeasurement(amount: 1.0625)
		let test = gallon1 + gallon2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testGallonPlusOunce() {
		let gallon1 = GallonMeasurement(amount: 1)
		let gallon2 = OunceMeasurement(amount: 1)
		let answer = GallonMeasurement(amount: 1.0078125)
		let test = gallon1 + gallon2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testGallonPlusTablespoon() {
		let gallon1 = GallonMeasurement(amount: 1)
		let gallon2 = TablespoonMeasurement(amount: 1)
		let answer = GallonMeasurement(amount: 1.00390625)
		let test = gallon1 + gallon2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testGallonPlusTeaspoon() {
		let gallon1 = GallonMeasurement(amount: 1)
		let gallon2 = TeaspoonMeasurement(amount: 1)
		let answer = GallonMeasurement(amount: 1.0013020833333333)
		let test = gallon1 + gallon2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	// MARK: - Quart Addition
	func testQuartPlusQuart() {
		let quart1 = QuartMeasurement(amount: 1)
		let quart2 = QuartMeasurement(amount: 1)
		let answer = QuartMeasurement(amount: 2)
		let test = quart1 + quart2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testQuartPlusGallon() {
		let quart = QuartMeasurement(amount: 1)
		let gallon = GallonMeasurement(amount: 1)
		let answer = QuartMeasurement(amount: 5)
		let test = quart + gallon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testQuartPlusCup() {
		let quart = QuartMeasurement(amount: 1)
		let cup = CupMeasurement(amount: 1)
		let answer = QuartMeasurement(amount: 1.25)
		let test = quart + cup
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testQuartPlusOunce() {
		let quart = QuartMeasurement(amount: 1)
		let ounce = OunceMeasurement(amount: 1)
		let answer = QuartMeasurement(amount: 1.03125)
		let test = quart + ounce
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testQuartPlusTablespoon() {
		let quart = QuartMeasurement(amount: 1)
		let tablespoon = TablespoonMeasurement(amount: 1)
		let answer = QuartMeasurement(amount: 1.015625)
		let test = quart + tablespoon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testQuartPlusTeaspoon() {
		let quart = QuartMeasurement(amount: 1)
		let teaspoon = TeaspoonMeasurement(amount: 1)
		let answer = QuartMeasurement(amount: 1.0052083333333333)
		let test = quart + teaspoon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	// MARK: - Cup Addition
	func testCupPlusCup() {
		let cup1 = CupMeasurement(amount: 1)
		let cup2 = CupMeasurement(amount: 1)
		let answer = CupMeasurement(amount: 2)
		let test = cup1 + cup2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testCupPlusQuart() {
		let cup = CupMeasurement(amount: 1)
		let quart = QuartMeasurement(amount: 1)
		let answer = CupMeasurement(amount: 5)
		let test = cup + quart
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testCupPlusOunce() {
		let cup = CupMeasurement(amount: 1)
		let ounce = OunceMeasurement(amount: 1)
		let answer = CupMeasurement(amount: 1.125)
		let test = cup + ounce
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testCupPlusTablespoon() {
		let cup = CupMeasurement(amount: 1)
		let tablespoon = TablespoonMeasurement(amount: 1)
		let answer = CupMeasurement(amount: 1.0625)
		let test = cup + tablespoon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testCupPlusTeaspoon() {
		let cup = CupMeasurement(amount: 1)
		let teaspoon = TeaspoonMeasurement(amount: 1)
		let answer = CupMeasurement(amount: 1.0208333333333333)
		let test = cup + teaspoon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testCupPlusGallon() {
		let cup = CupMeasurement(amount: 1)
		let gallon = GallonMeasurement(amount: 1)
		let answer = CupMeasurement(amount: 17)
		let test = cup + gallon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	// MARK: - Tablespoon Addition
	
	func testTablespoonPlusTablespoon() {
		let tablespoon1 = TablespoonMeasurement(amount: 1)
		let tablespoon2 = TablespoonMeasurement(amount: 1)
		let answer = TablespoonMeasurement(amount: 2)
		let test = tablespoon1 + tablespoon2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTablespoonPlusGallon() {
		let tablespoon = TablespoonMeasurement(amount: 1)
		let gallon = GallonMeasurement(amount: 1)
		let answer = TablespoonMeasurement(amount: 257)
		let test = tablespoon + gallon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTablespoonPlusQuart() {
		let tablespoon = TablespoonMeasurement(amount: 1)
		let quart = QuartMeasurement(amount: 1)
		let answer = TablespoonMeasurement(amount: 65)
		let test = tablespoon + quart
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTablespoonPlusCup() {
		let tablespoon = TablespoonMeasurement(amount: 1)
		let cup = CupMeasurement(amount: 1)
		let answer = TablespoonMeasurement(amount: 17)
		let test = tablespoon + cup
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTablespoonPlusOunce() {
		let tablespoon = TablespoonMeasurement(amount: 1)
		let ounce = OunceMeasurement(amount: 1)
		let answer = TablespoonMeasurement(amount: 3)
		let test = tablespoon + ounce
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTablespoonPlusTeaspoon() {
		let tablespoon = TablespoonMeasurement(amount: 1)
		let teaspoon = TeaspoonMeasurement(amount: 1)
		let answer = TablespoonMeasurement(amount: 1.3333333333333333)
		let test = tablespoon + teaspoon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}

	// MARK: - Teaspoon Addition
	
	func testTeaspoonPlusTeaspoon() {
		let teaspoon1 = TeaspoonMeasurement(amount: 1)
		let teaspoon2 = TeaspoonMeasurement(amount: 1)
		let answer = TeaspoonMeasurement(amount: 2)
		let test = teaspoon1 + teaspoon2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTeaspoonPlusGallon() {
		let teaspoon = TeaspoonMeasurement(amount: 1)
		let gallon = GallonMeasurement(amount: 1)
		let answer = TeaspoonMeasurement(amount: 769)
		let test = teaspoon + gallon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTeaspoonPlusQuart() {
		let teaspoon = TeaspoonMeasurement(amount: 1)
		let quart = QuartMeasurement(amount: 1)
		let answer = TeaspoonMeasurement(amount: 193)
		let test = teaspoon + quart
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTeaspoonPlusCup() {
		let teaspoon = TeaspoonMeasurement(amount: 1)
		let cup = CupMeasurement(amount: 1)
		let answer = TeaspoonMeasurement(amount: 49)
		let test = teaspoon + cup
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTeaspoonPlusOunce() {
		let teaspoon = TeaspoonMeasurement(amount: 1)
		let ounce = OunceMeasurement(amount: 1)
		let answer = TeaspoonMeasurement(amount: 7)
		let test = teaspoon + ounce
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testTeaspoonPlusTablespoon() {
		let teaspoon = TeaspoonMeasurement(amount: 1)
		let tablespoon = TablespoonMeasurement(amount: 1)
		let answer = TeaspoonMeasurement(amount: 4)
		let test = teaspoon + tablespoon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	// MARK: - Ounce Addition
	
	func testOuncePlusOunce() {
		let ounce1 = OunceMeasurement(amount: 1)
		let ounce2 = OunceMeasurement(amount: 1)
		let answer = OunceMeasurement(amount: 2)
		let test = ounce1 + ounce2
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testOuncePlusGallon() {
		let ounce = OunceMeasurement(amount: 1)
		let gallon = GallonMeasurement(amount: 1)
		let answer = OunceMeasurement(amount: 129)
		let test = ounce + gallon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testOuncePlusQuart() {
		let ounce = OunceMeasurement(amount: 1)
		let quart = QuartMeasurement(amount: 1)
		let answer = OunceMeasurement(amount: 33)
		let test = ounce + quart
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testOuncePlusCup() {
		let ounce = OunceMeasurement(amount: 1)
		let cup = CupMeasurement(amount: 1)
		let answer = OunceMeasurement(amount: 9)
		let test = ounce + cup
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testOuncePlusTablespoon() {
		let ounce = OunceMeasurement(amount: 1)
		let tablespoon = TablespoonMeasurement(amount: 1)
		let answer = OunceMeasurement(amount: 1.5)
		let test = ounce + tablespoon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
	
	func testOuncePlusTeaspoon() {
		let ounce = OunceMeasurement(amount: 1)
		let teaspoon = TeaspoonMeasurement(amount: 1)
		let answer = OunceMeasurement(amount: 1 + (1/6))
		let test = ounce + teaspoon
		print("test: \(test)")
		print("answer: \(answer)")
		XCTAssertTrue(test == answer)
	}
}
