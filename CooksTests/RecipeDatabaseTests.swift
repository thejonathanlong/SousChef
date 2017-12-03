//
//  RecipeDatabaseTests.swift
//  CooksTests
//
//  Created by Jonathan Long on 11/27/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import XCTest

// MARK: - Recipe Fetching Tests
class SousChefDatabaseTests: CooksTestCase {
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
		sousChefDatabase.recipe(named: "Vegan Cinnamon Rolls") { (recipes) in
			self.sousChefDatabase.ingredients(for: recipes.first!) { (ingredients) in
				XCTAssertTrue(ingredients.count == 1)
				guard let ingredient = ingredients.first else {
					XCTAssertTrue(false)
					return
				}
				XCTAssertTrue(ingredient.item == "sugar")
				semaphore.signal()
			}
		}
		semaphore.wait()
	}
	
}
