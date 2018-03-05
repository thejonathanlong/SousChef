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
	
	func save(recipe: Recipe, onCompletionBlock: @escaping ([CKRecord]?, [CKRecordID]?, Error?) -> Void) {
		var recordsToSave: [CKRecord] = []
		var ingredientReferences: [CKReference] = []
		let recipeRecord = recipe.record
		if let recipeImage = recipe.image {
			recipeRecord[Recipe.recordImageKey] = imageAsset(recipeRecord: recipeRecord, image: recipeImage)
		}
		for ingredient in recipe.ingredients {
			let ingredientRecord = ingredient.record
//			ingredientRecord.parent = CKReference(record: recipeRecord, action: .none)
			recordsToSave.append(ingredientRecord)
			ingredientReferences.append(CKReference(record: ingredientRecord, action: .deleteSelf))
		}
		
		recipeRecord[Recipe.recordIngredientsKey] = ingredientReferences as CKRecordValue
		
		// Add the recipeRecord after setting the ingredient records on the recipe.
		recordsToSave.append(recipeRecord)
		let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: nil)
		modifyRecordsOperation.modifyRecordsCompletionBlock = { recordsOrNil, reocrdIDsOrNil, errorOrNil in
			recipe.backingRecord = recipeRecord
			onCompletionBlock(recordsOrNil, reocrdIDsOrNil, errorOrNil)
		}
		modifyRecordsOperation.savePolicy = .changedKeys
		
		modifyRecordsOperation.start()
		
	}
	
	func imageAsset(recipeRecord: CKRecord, image: UIImage) -> CKAsset {
		let temporaryDirectoryPath = NSTemporaryDirectory() as NSString
		
		let imagePath = temporaryDirectoryPath.appendingPathComponent(recipeRecord.recordID.recordName)
		let imageURL = URL(fileURLWithPath: imagePath.appendingFormat(".%@.dat", UUID().uuidString))
		let data = UIImagePNGRepresentation(image)
		do {
			try data?.write(to: imageURL)
		}
		catch {
			print("There was an error writing to \(imageURL)")
		}
		
		return CKAsset(fileURL: imageURL)
	}
}

// MARK - Deleting Recipes
extension SousChefDatabase {
	func delete(recipe: Recipe, completion: @escaping (CKRecordID?, Error?) -> Void) {
		privateDB.delete(withRecordID: recipe.record.recordID, completionHandler: completion)
	}
}

// MARK - Saving Ingredients
extension SousChefDatabase {
	func saveSynchronously(ingredient item: String, original: String, measurementAmount: Double, measurementType: String) -> CKRecordID {
		let ingredientRecord = CKRecord(recordType: SousChefDatabase.ingredientRecordType)
		ingredientRecord[Ingredient.recordItemKey] = item as CKRecordValue
		ingredientRecord[Ingredient.recordOriginalKey] = original as CKRecordValue
		ingredientRecord[Ingredient.recordMeasurementAmountKey] = measurementAmount as CKRecordValue
		ingredientRecord[Ingredient.recordMeasurementTypeKey] = measurementType as CKRecordValue
		
		let semaphore = DispatchSemaphore(value: 0)
		var recordID = CKRecordID(recordName: SousChefDatabase.ingredientRecordType)
		privateDB.save(ingredientRecord) { (recordOrNil, errorOrNil) in
			guard let ingredientRecord = recordOrNil else { print("There was a problem saving the record..."); return }
			if let error = errorOrNil {
				print("There was a problem saving the record...\(error)")
				return
			}
			recordID = ingredientRecord.recordID
		}
		semaphore.wait()
		
		return recordID
	}
	
	func saveSynchronously(ingredient: Ingredient) -> CKRecordID {
		return saveSynchronously(ingredient: ingredient.item, original: ingredient.original, measurementAmount: ingredient.measurement.amount, measurementType: ingredient.measurement.type.rawValue)
	}
}



