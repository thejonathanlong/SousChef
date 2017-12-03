//
//  RecipeDatabase.swift
//  Cooks
//
//  Created by Jonathan Long on 11/15/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit
import CloudKit

class SousChefDatabase: NSObject {
	static let recipeRecordType = "Recipe"
	static let ingredientRecordType = "Ingredient"
	static let measurementRecordType = "Measurement"
	
	let publicDB = CKContainer.default().publicCloudDatabase
	let privateDB = CKContainer.default().privateCloudDatabase
}

typealias RecipeFetchCompletion = ([Recipe]) -> Void

// MARK: - Fetching Recipes
extension SousChefDatabase {
	func recipe(named: String, completion: @escaping RecipeFetchCompletion) {
		recipe(named: named, loadingIngredients: false, completion: completion)
	}
	
	func recipes(completion: @escaping RecipeFetchCompletion) {
		databaseRecipeQuery(predicate: NSPredicate(value: true), loadingIngredients: false, completion: completion)
	}
	
	func recipe(tagged: String, completion: @escaping RecipeFetchCompletion) {
		let predicate = NSPredicate(format: "tags CONTAINS[cd] %@", tagged)
		databaseRecipeQuery(predicate: predicate, loadingIngredients: false, completion: completion)
	}
	
	func databaseRecipeQuery(predicate: NSPredicate, loadingIngredients: Bool, completion: @escaping RecipeFetchCompletion) {
		let query = CKQuery(recordType: SousChefDatabase.recipeRecordType, predicate: predicate)
		
		privateDB.perform(query, inZoneWith: nil) { (recordsOrNil, errorOrNil) in
			guard let records = recordsOrNil else {
				print("rcords were nil for query: \(query)")
				completion([])
				return
			}
			let recipes = self.recipesfrom(records: records)
			if loadingIngredients {
				for var recipe in recipes {
					recipe.loadAllIngredients()
				}
				completion(recipes)
			}
			else {
				completion(recipes)
			}
		}
	}
	
	func recipe(named: String, loadingIngredients: Bool, completion: @escaping RecipeFetchCompletion) {
		let predicate = NSPredicate(format: "name = %@", named)
		databaseRecipeQuery(predicate: predicate, loadingIngredients: loadingIngredients, completion: completion)
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

// MARK: - Recipe from Record
extension Recipe {
	static let recordNameKey = "name"
	static let recordIngredientsKey = "ingredients"
	static let recordInstructionsKey = "instructions"
	static let recordImageKey = "image"
	static let recordTagsKey = "tags"
	
	init(record: CKRecord) {
		name = record[Recipe.recordNameKey] as! String
		if let references = record[Recipe.recordIngredientsKey] as? [CKReference] {
			var recordIDs : [CKRecordID] = []
			for ingredientReference in references {
				recordIDs.append(ingredientReference.recordID)
			}
			ingredientRecordIDs = recordIDs
		}
		else {
			ingredientRecordIDs = []
		}
		
		instructions = record[Recipe.recordInstructionsKey] as! [String]
		image = Recipe.recipeImage(record)
		
		tags = record[Recipe.recordTagsKey] != nil ? record[Recipe.recordTagsKey] as! [String] : []
	}
	
	static func recipeImage(_ record: CKRecord) -> UIImage? {
		guard let asset = record[Recipe.recordImageKey] as? CKAsset else { return nil }
		do {
			let data = try Data(contentsOf: asset.fileURL)
			return UIImage(data: data)
		}
		catch {
			print("There was an error creating the data from the file \(asset.fileURL) - \(error)")
		}
		
		return nil
	}
	
	// This method might take a long time to finish...
	mutating func loadAllIngredients() {
		loadIngredients(ingredientRecordIDs)
	}
	
	mutating func loadIngredients(_ recordIDs: [CKRecordID]) {
		let ingredientsFetchOperation = CKFetchRecordsOperation(recordIDs: recordIDs)
		var ingredients: [Ingredient] = []
		let allIngredientsLoadedSemaphore = DispatchSemaphore(value: 0)
//		ingredientsFetchOperation.perRecordCompletionBlock = { recordOrNil, recordIDOrNil, errorOrNil in
//			guard let ingredientRecord = recordOrNil else { print("record was nil for record ID \(String(describing: recordIDOrNil))"); return }
//			let ingredient = Ingredient(record: ingredientRecord)
////			self.mutableIngredients.append(ingredient)
//			ingredients.append(ingredient)
//		}
		
		ingredientsFetchOperation.fetchRecordsCompletionBlock = { recordsByRecordIDOrNil, errorOrNil in
			guard let recordsByRecordID = recordsByRecordIDOrNil else { print("There were no records for the ingredient record IDs."); return }
			for recordValue in recordsByRecordID.values {
				let ingredient = Ingredient(record: recordValue)
				ingredients.append(ingredient)
			}
			print("All ingredients loaded!")
			allIngredientsLoadedSemaphore.signal()
		}
		print("Waiting for all ingredients to load.")
		allIngredientsLoadedSemaphore.wait()
		mutableIngredients.append(contentsOf: ingredients)
	}
}

// MARK: - Record from Recipe
extension Recipe {
	var record: CKRecord {
		let record = CKRecord(recordType: SousChefDatabase.recipeRecordType)
		record[Recipe.recordNameKey] = name as CKRecordValue
		record[Recipe.recordIngredientsKey] = ingredients as CKRecordValue
		record[Recipe.recordTagsKey] = tags as CKRecordValue
		record[Recipe.recordInstructionsKey] = instructions as CKRecordValue
		if let image = image {
			record[Recipe.recordImageKey] = image as? CKRecordValue
		}
		
		return record
	}
}

// MARK: Ingredient from Record
extension Ingredient {
	static let recordItemKey = "item"
	static let recordOriginalKey = "original"
	static let recordMeasurementTypeKey = "measurementType"
	static let recordMeasurementAmountKey = "measurementAmount"
	
	init(record: CKRecord) {
		let measurementType = record[Ingredient.recordMeasurementTypeKey] as! String
		let measurementAmount = record[Ingredient.recordMeasurementAmountKey] as! Double
		self.init(measurementType: MeasurementType(rawValue: measurementType)!, amount: measurementAmount, item: record[Ingredient.recordItemKey] as! String, original: record[Ingredient.recordOriginalKey] as! String)
		
	}
}

