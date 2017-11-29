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
		let predicate = NSPredicate(format: "name = %@", named)
		databaseRecipeQuery(predicate: predicate, completion: completion)
	}
	
	func recipes(completion: @escaping RecipeFetchCompletion) {
		databaseRecipeQuery(predicate: NSPredicate(value: true), completion: completion)
	}
	
	func recipe(tagged: String, completion: @escaping RecipeFetchCompletion) {
		let predicate = NSPredicate(format: "tags CONTAINS[cd] %@", tagged)
		databaseRecipeQuery(predicate: predicate, completion: completion)
	}
	
	func databaseRecipeQuery(predicate: NSPredicate, completion: @escaping RecipeFetchCompletion) {
		let query = CKQuery(recordType: SousChefDatabase.recipeRecordType, predicate: predicate)
		
		privateDB.perform(query, inZoneWith: nil) { (recordsOrNil, errorOrNil) in
			guard let records = recordsOrNil else { print("rcords were nil for query: \(query)"); return }
			var recipes: [Recipe] = []
			for record in records {
				let recipe = Recipe(record: record)
				recipes.append(recipe)
			}
			completion(recipes)
		}
	}
	
//	func recipeWith
}

// MARK: - Fetching Ingredients
extension SousChefDatabase {
	func ingredients(for recipe: Recipe, completion: @escaping ([Ingredient]) -> Void) {
		let predicate = NSPredicate(format: "name == %@", recipe.name)
		let query = CKQuery(recordType: SousChefDatabase.recipeRecordType, predicate: predicate)
		
		privateDB.perform(query, inZoneWith: nil) { (recordsOrNil, errorOrNil) in
			guard let records = recordsOrNil, let firstRecord = records.first else { print("records were nil for query: \(query)"); return }
			let recipe = Recipe(record: firstRecord)
			
			completion(recipe.ingredients)
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
		ingredients = record[Recipe.recordIngredientsKey] as! [Ingredient]
		instructions = record[Recipe.recordInstructionsKey] as! [String]
		image = Recipe.recipeImage(record)
		tags = record[Recipe.recordTagsKey] as! [String]
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
}

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


