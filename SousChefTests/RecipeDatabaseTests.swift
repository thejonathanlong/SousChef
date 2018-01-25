//
//  RecipeDatabaseTests.swift
//  CooksTests
//
//  Created by Jonathan Long on 11/27/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import XCTest

// MARK: - Recipe Fetching Tests
class SousChefDatabaseTests: SousChefTestCase {
    let sousChefDatabase = SousChefDatabase()
	
	override func setUp() {
		super.setUp()
		XCTAssertNotNil(FileManager.default.ubiquityIdentityToken) // If this fails the user is not logged into iCloud
	}
	
	func testAllRecipes() {
		let semaphore = DispatchSemaphore(value: 0)
		sousChefDatabase.recipes { (recipes) in
			XCTAssertTrue(recipes.count == 1)
			guard let recipe = recipes.first else {
				XCTAssertTrue(false)
				semaphore.signal()
				return
			}
			XCTAssertTrue(recipe.name == "Vegan Cinnamon Rolls")
			semaphore.signal()
		}
		semaphore.wait()
	}
	
	func testRecipeNamedVeganCinnamonRolls() {
		let semaphore = DispatchSemaphore(value: 0)
		sousChefDatabase.recipe(named: "Vegan Cinnamon Rolls") { (recipes) in
			guard let recipe = recipes.first else {
				XCTAssertTrue(false)
				semaphore.signal()
				return
			}
			XCTAssertTrue(recipe.name == "Vegan Cinnamon Rolls")
			semaphore.signal()
		}
		semaphore.wait()
	}
}

// MARK: - Ingredient Fetching Tests
extension SousChefDatabaseTests {
	
	func testRecipeIngredientsForVeganCinnamonRolls() {
		let semaphore = DispatchSemaphore(value: 0)
		sousChefDatabase.recipe(named: "Vegan Cinnamon Rolls", loadingIngredients: true) { (recipes) in
			guard let recipe = recipes.first else { XCTAssertTrue(false); semaphore.signal(); return }
			
			XCTAssertTrue(recipe.ingredients.count == 1)
			guard let ingredient = recipe.ingredients.first else {
				XCTAssertTrue(false)
				semaphore.signal()
				return
			}
			XCTAssertTrue(ingredient.item == "sugar")
			XCTAssertTrue(ingredient.measurement.amount == 1.0)
			XCTAssertTrue(ingredient.measurement.type == .cup)
			XCTAssertTrue(ingredient.original == "1 cup of cane sugar")
			semaphore.signal()
		}
		semaphore.wait()
	}
	
	//TODO: Test the performance of this
	/*
	func testPerformanceOfRecipeWithManyIngredients() {
		self.measure {
			sousChefDatabase.ingredients(for: <#T##Recipe#>, completion: <#T##IngredientFetchCompletion##IngredientFetchCompletion##([Ingredient]) -> Void#>)
		}
	}
*/
	
}
