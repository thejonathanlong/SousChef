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
	
	func testAllRecipes() {
		var recipes: [Recipe] = []
		sousChefDatabase.recipes { (recipe) in
			recipes.append(recipe)
		}
		XCTAssertTrue(recipes.count == 1)
		
		XCTAssertTrue(recipes.first!.name == "Vegan Cinnamon Rolls")
	}
	
	func testRecipeNamedVeganCinnamonRolls() {
		sousChefDatabase.recipe(named: "Vegan Cinnamon Rolls") { (recipe) in
			XCTAssertTrue(recipe.name == "Vegan Cinnamon Rolls")
		}
	}
}

// MARK: - Ingredient Fetching Tests
extension SousChefDatabaseTests {
	func testRecipeIngredientsForVeganCinnamonRolls() {
		sousChefDatabase.recipe(named: "Vegan Cinnamon Rolls") { (recipe) in
			self.sousChefDatabase.ingredients(for: recipe) { (ingredients) in
				XCTAssertTrue(ingredients.count == 1)
				XCTAssertTrue(ingredients.first!.item == "sugar")
			}
		}
	}
}
