//
//  RecipeDatabase.swift
//  Cooks
//
//  Created by Jonathan Long on 11/15/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit
import CloudKit

// MARK: - SousChefDatabase Class
class SousChefDatabase: NSObject {
	static let recipeRecordType = "Recipe"
	static let ingredientRecordType = "Ingredient"
	static let measurementRecordType = "Measurement"
	
	let publicDB = CKContainer.default().publicCloudDatabase
	let privateDB = CKContainer.default().privateCloudDatabase
	
	static let shared = SousChefDatabase()
}

// MARK: - Fetching Recipes
typealias RecipeFetchCompletion = ([Recipe]) -> Void

extension SousChefDatabase {
	func recipe(named: String, completion: @escaping RecipeFetchCompletion) {
		recipe(named: named, loadingIngredients: false, completion: completion)
	}
	
	func recipe(named: String, loadingIngredients: Bool, completion: @escaping RecipeFetchCompletion) {
		let predicate = NSPredicate(format: "name = %@", named)
		databaseRecipeQuery(predicate: predicate, loadingIngredients: loadingIngredients, completion: completion)
	}
	
	func recipes(completion: @escaping RecipeFetchCompletion) {
		databaseRecipeQuery(predicate: NSPredicate(value: true), loadingIngredients: false, completion: completion)
	}
	
	func recipe(tagged: String, completion: @escaping RecipeFetchCompletion) {
		let predicate = NSPredicate(format: "tags CONTAINS[cd] %@", tagged)
		databaseRecipeQuery(predicate: predicate, loadingIngredients: false, completion: completion)
	}
	
	func databaseRecipeQuery(predicate: NSPredicate, loadingIngredients: Bool, completion: @escaping RecipeFetchCompletion) {
		let recipeQuery = CKQuery(recordType: SousChefDatabase.recipeRecordType, predicate: predicate)
		
		privateDB.perform(recipeQuery, inZoneWith: nil) { (recordsOrNil, errorOrNil) in
			
			guard let records = recordsOrNil else {
				print("rcords were nil for query: \(recipeQuery)")
				completion([])
				return
			}
			
			let recipes = self.recipesfrom(records: records)
			if loadingIngredients {
				for recipe in recipes {
					recipe.loadAllIngredients()
				}
			}
			completion(recipes)
		}
	}
	
	func recipesfrom(records: [CKRecord]) -> [Recipe] {
		var recipes: [Recipe] = []
		for record in records {
			let recipe = Recipe(record: record)
			recipes.append(recipe)
		}
		return recipes
	}
	
//	func recipeWith
}

// MARK: - Fetching Ingredients
typealias IngredientFetchCompletion = ([Ingredient]) -> Void

extension SousChefDatabase {
	
	func ingredients(for recipe: Recipe, completion: @escaping IngredientFetchCompletion) {
		let predicate = NSPredicate(format: "name = %@", recipe.name)
		let query = CKQuery(recordType: SousChefDatabase.recipeRecordType, predicate: predicate)
		
		privateDB.perform(query, inZoneWith: nil) { (recordsOrNil, errorOrNil) in
			guard let records = recordsOrNil, let firstRecord = records.first else {
				print("records were nil for query: \(query)")
				completion([])
				return
			}
			let recipe = Recipe(record: firstRecord)
			recipe.loadAllIngredients()
			
			completion(recipe.ingredients)
		}
	}
	
	func ingredient(from reference: CKReference, completion: @escaping IngredientFetchCompletion) {
		let predicate = NSPredicate(format: "recordName = %@", reference.recordID.recordName)
		let query = CKQuery(recordType: SousChefDatabase.ingredientRecordType, predicate: predicate)
		
		privateDB.perform(query, inZoneWith: nil) { (recordsOrNil, errorOrNil) in
			guard let records = recordsOrNil, let firstRecord = records.first else {
				print("records were nil for query: \(query)")
				completion([])
				return
			}
			
			completion([Ingredient(record: firstRecord)])
		}
	}
}


// MARK - Saving Recipes
extension SousChefDatabase {
	func save(recipes: [Recipe], onCompletionBlock: @escaping ([CKRecord]?, [CKRecordID]?, Error?) -> Void) {
		var records: [CKRecord] = []
		for recipe in recipes {
			records.append(recipe.record)
		}
		let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
		modifyRecordsOperation.modifyRecordsCompletionBlock = onCompletionBlock
		modifyRecordsOperation.savePolicy = .changedKeys
		
		modifyRecordsOperation.start()
	}
}

